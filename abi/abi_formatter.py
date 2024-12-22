import json
import os
import glob

def process_abis():
    # Path to the abi directory
    abi_dir = "."
    
    # Find all JSON files in subdirectories
    json_files = glob.glob(os.path.join(abi_dir, "**/*.json"), recursive=True)
    
    for json_file in json_files:
        try:
            with open(json_file, 'r') as f:
                data = json.load(f)
            
            if 'abi' in data:
                # Get contract name and current directory
                contract_name = os.path.basename(json_file).replace('.json', '')
                current_dir = os.path.dirname(json_file)
                
                # Create the abi.json in the same directory
                output_file = os.path.join(current_dir, f"{contract_name}.abi.json")
                
                # Write the ABI file
                with open(output_file, 'w') as f:
                    json.dump(data['abi'], f, indent=2)
                
                print(f"Extracted ABI for {contract_name}")
            
        except Exception as e:
            print(f"Error processing {json_file}: {str(e)}")

if __name__ == "__main__":
    process_abis()