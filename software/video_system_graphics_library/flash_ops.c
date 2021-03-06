/*
 * sdcard_ops.c
 *
 * Functions to handle loading bitmaps and files from SD cards
 *
 *  Created on: Mar 20, 2016
 *      Author: stephen
 */

#include <system.h>
#include <stdlib.h>
#include <stdio.h>

#include <altera_avalon_sgdma.h>
#include <altera_avalon_sgdma_descriptor.h>
#include <altera_avalon_sgdma_regs.h>

#include "graphics_defs.h"
#include "flash_ops.h"

#define FILE_CHUNK_SIZE 2048
#define BMP_PIXDATA_OFFSET 0x0A
#define BMP_TYPE_OFFSET 0x0E
#define BMP_WIDTH_OFFSET 0x12
#define BMP_HEIGHT_OFFSET 0x16
#define BMP_BITS_OFFSET 0x1C

static int min(int a, int b) {
	if (a < b) return a;
	else return b;
}


/**
 * load_bmp: Read a bitmap file from SD card to SDRAM
 *
 * Arguments:
 *     file_name: String with the name of the file to open
 *     pixbuf: Pointer to pixbuf_t struct for output
 * Returns:
 *     0 on success, otherwise failure.
 */
char load_flash_bmp(char *file_name, pixbuf_t *pixbuf)
{
	FILE *file;
	unsigned char buffer[FILE_CHUNK_SIZE];
	int pixdata_offset, i, bytes_read, status;
	alt_sgdma_descriptor descriptor, next_descriptor;
	alt_sgdma_dev *dev;

	if ((file = fopen(file_name, "r")) == 0) {
		return -E_IO;
	}

	// Read the first block of the file to get metadata
	fseek(file, 0, SEEK_SET);
	fread(buffer, 1, FILE_CHUNK_SIZE, file);

	// Read bitmap metadata
	pixdata_offset = *((short *) (buffer + BMP_PIXDATA_OFFSET));
	if (*(buffer + BMP_TYPE_OFFSET) != 40) {
		fclose(file);
		return -E_INVALID_BMP;
	}
	pixbuf->width = *((unsigned short *) (buffer + BMP_WIDTH_OFFSET));
	pixbuf->height = *((unsigned short *) (buffer + BMP_HEIGHT_OFFSET));

	// Check that we have an 8-bit bitmap
	if (*((short *) (buffer + BMP_BITS_OFFSET)) != 8) {
		fclose(file);
		return -E_INVALID_BMP;
	}

	// To simplify logic, require that the image width is less than
	// the size of our copy chunk size
	if (pixbuf->width > FILE_CHUNK_SIZE) {
		fclose(file);
		return -E_INVALID_BMP;
	}

	// Allocate memory for our pixel buffer
	pixbuf->base_address = malloc(pixbuf->width * pixbuf->height);
	if (pixbuf->base_address == NULL) {
		fclose(file);
		return -E_NOMEM;
	}

	// Advance the file pointer to the beginning of the image
	fseek(file, pixdata_offset, SEEK_SET);

	// Initialize the DMA copier
	dev = alt_avalon_sgdma_open(SGDMA_0_NAME);
	if (dev == NULL) {
		free(pixbuf->base_address);
		fclose(file);
		return -E_IO;
	}

	// Copy the bitmap, mirroring in the y-direction to match our coordinate system
	for (i = pixbuf->height-1; i >= 0; --i)
	{
		bytes_read = fread(buffer, 1, pixbuf->width, file);
		alt_avalon_sgdma_construct_mem_to_mem_desc(
				&descriptor,
				&next_descriptor,
				(alt_u32 *) buffer,
				(alt_u32 *) (pixbuf->base_address + i*pixbuf->width),
				bytes_read,
				0,
				0);
		status = alt_avalon_sgdma_do_sync_transfer(dev, &descriptor);
	}

	// Close the file
	if (fclose(file) != 0) {
		free(pixbuf->base_address);
		return -E_IO;
	}

	return 0;
}

/**
 * load_file: Read a file from SD card to SDRAM
 *
 * Arguments:
 *     file_name: String with the name of the file to open
 *     dest_addr: Pointer to output buffer
 *     dest_size: Size of output buffer
 * Returns:
 *     0 on success, otherwise failure.
 */
char load_flash_file(char *file_name, void *dest_addr, unsigned int dest_size)
{
	FILE *file;
	unsigned char buffer[FILE_CHUNK_SIZE];
	unsigned int offset;
	int bytes_read, bytes_to_copy, status;
	alt_sgdma_descriptor descriptor, next_descriptor;
	alt_sgdma_dev *dev;

	if ((file = fopen(file_name, "r")) == 0) {
		return -E_IO;
	}

	// Open the DMA device
	dev = alt_avalon_sgdma_open(SGDMA_0_NAME);
	if (dev == 0) {

		fclose(file);
		return -E_IO;
	}

	fseek(file, 0, SEEK_END);
	unsigned int file_size = ftell(file);
	fseek(file, 0, SEEK_SET);
	offset = 0;
	while (offset < file_size)
	{
		bytes_read = fread(buffer, 1, FILE_CHUNK_SIZE, file);
		bytes_to_copy = min(bytes_read, dest_size - offset);
		alt_avalon_sgdma_construct_mem_to_mem_desc(
				&descriptor,
				&next_descriptor,
				(alt_u32 *) buffer,
				(alt_u32 *) (dest_addr + offset),
				bytes_to_copy,
				0,
				0);
		status = alt_avalon_sgdma_do_sync_transfer(dev, &descriptor);
		offset += bytes_read;
	}

	// Close the file
	if (fclose(file) != 0) {
		return -E_IO;
	}

	return 0;
}
