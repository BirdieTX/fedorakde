#!/bin/bash

df -B1 -x tmpfs -x devtmpfs -x squashfs -x overlay \
  | awk 'NR>1 {
      fs=$1; size=$2; used=$3
      if (!seen[fs]++) {
          total_size+=size
          total_used+=used
      }
  }
  END {
      printf "%.2fTB / %.2fTB\n", total_used/1e12, total_size/1e12
  }'
