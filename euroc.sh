#!/bin/bash

BASE_URL="http://robotics.ethz.ch/~asl-datasets/ijrr_euroc_mav_dataset"

declare -A datasets=(
  ["MH01"]="machine_hall/MH_01_easy/MH_01_easy.zip"
  ["MH02"]="machine_hall/MH_02_easy/MH_02_easy.zip"
  ["MH03"]="machine_hall/MH_03_medium/MH_03_medium.zip"
  ["MH04"]="machine_hall/MH_04_difficult/MH_04_difficult.zip"
  ["MH05"]="machine_hall/MH_05_difficult/MH_05_difficult.zip"
  ["V101"]="vicon_room1/V1_01_easy/V1_01_easy.zip"
  ["V102"]="vicon_room1/V1_02_medium/V1_02_medium.zip"
  ["V103"]="vicon_room1/V1_03_difficult/V1_03_difficult.zip"
  ["V201"]="vicon_room2/V2_01_easy/V2_01_easy.zip"
  ["V202"]="vicon_room2/V2_02_medium/V2_02_medium.zip"
  ["V203"]="vicon_room2/V2_03_difficult/V2_03_difficult.zip"
)

mkdir -p Datasets/EuRoC
cd Datasets/EuRoC

for key in "${!datasets[@]}"; do
  zip_file="${key}.zip"
  extract_dir="${key}"

  # Check if the extraction directory exists
  if [ ! -d "$extract_dir" ]; then
    # If the ZIP file exists, check for integrity
    if [ -f "$zip_file" ]; then
      if ! unzip -t "$zip_file" > /dev/null; then
        echo "Warning: $zip_file appears to be corrupt. Re-downloading..."
        rm "$zip_file"  # Remove the corrupt file
        full_url="$BASE_URL/${datasets[$key]}"
        wget -O "$zip_file" "$full_url" --show-progress
      fi
    else
      # Download the ZIP if it does not exist
      full_url="$BASE_URL/${datasets[$key]}"
      echo "Downloading $key from $full_url"
      wget -O "$zip_file" "$full_url" --show-progress
    fi

    # Attempt to extract the ZIP file again
    if [ -f "$zip_file" ] && unzip -t "$zip_file" > /dev/null; then
      echo "Extracting $zip_file..."
      unzip -q "$zip_file" -d "$extract_dir"
    else
      echo "Error: Unable to verify $zip_file after download. It may still be corrupt."
    fi
  else
    echo "$key is already extracted."
  fi
done

cd ../../Examples
chmod +x euroc_examples.sh
./euroc_examples.sh
