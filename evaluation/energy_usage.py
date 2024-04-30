import sys
from datetime import datetime

def compute_energy(file_path):
    energy = 0.0
    last_time = None
    last_power = None

    with open(file_path, 'r') as file:
        for line in file:
            timestamp_str, power_str = line.strip().split(', ')
            timestamp = datetime.strptime(timestamp_str[:-3], '%Y-%m-%d %H:%M:%S.%f')
            power = float(power_str)
            
            if last_time is not None:
                # Calculate the time difference between consecutive measurements in seconds
                delta_t = (timestamp - last_time).total_seconds()
                
                # Compute energy as the sum of power multiplied by time
                energy += (power + last_power) / 2 * delta_t
            
            # Update last time and last power
            last_time = timestamp
            last_power = power
    
    return energy

if __name__ == "__main__":
    if len(sys.argv) != 2:
        print("Usage: python script.py <input_file>")
        sys.exit(1)

    input_file = sys.argv[1]
    total_energy = compute_energy(input_file)
    print("Total energy consumed:", total_energy, "Joules")
