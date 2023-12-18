#!/bin/bash

get_terminal_width() {
    tput cols
}

generate_header() {
    local header_text="Metrics"
    local border_char="="
    local terminal_width=$(get_terminal_width)
    local border_length=$((terminal_width - ${#header_text}))
    local header_line="${header_text}\n$(printf "%${border_length}s" | tr ' ' $border_char)"
    echo -e "$header_line" >> metrics.txt
}


check_top(){
if ! command -v top  &> /dev/null; then
    echo "Error 'top' command isn't available."
set -e
fi
}

check_df(){
   if ! command -v df &> /dev/null; then
      echo "Error 'df' command isn't available."
set -e
fi
}

check_journalctl() {
   if ! command -v journalctl &> /dev/null; then
      echo "Error 'journalctl' command isn't available."
set -e
fi
}


get_cpu_usage(){
   top -b -n 1 | grep "%Cpu" >> metrics.txt	
}

get_memory_usage() {
   top -b -n 1 | grep "MiB Mem :" >> metrics.txt
}

get_tasks(){
   top -b -n 1 | grep "Tasks" >> metrics.txt
}

get_disk_usage() {
   df -h >> metrics.txt
}

   get_system_logs(){
      journalctl >> metrics.txt
   }

   get_services(){
   systemctl --type=service >> metrics.txt
   }

generate_header
check_top
check_df
get_cpu_usage
get_memory_usage
get_disk_usage
get_system_logs