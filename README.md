
# Get-ADC-DNSFlush.ps1

A PowerShell script for managing Active Directory and DNS cache on network computers. It retrieves a list of active computers from Active Directory, checks their availability, and flushes the DNS cache on selected machines. Ideal for system administrators looking to automate network maintenance tasks.

## Key Features
- **Generate a list of active computers**: Retrieves a list of all computers from Active Directory, checks their availability, and saves the list of active computers to a file.
- **Flush DNS cache**: Flushes the DNS cache on active computers via remote command execution.
- **Logging**: All operations are logged to a timestamped file for easy tracking.
- **Interactive menu**: A user-friendly, colorized menu for selecting actions, including generating a computer list, flushing DNS cache, and combined operations.

## Requirements
- **PowerShell 5.1 or higher**: The script is designed to work in Windows PowerShell 5.1 and above.
- **Active Directory module**: Required for working with Active Directory.
- **Administrative privileges**: The script must be run with administrative rights.


## Usage
1. **Run the script in PowerShell**:
   - Open PowerShell as an administrator.
   - Copy and paste the following command to download and execute the script directly from GitHub:
     ```powershell
     iex (irm "https://github.com/Sergio-Badanin/ADC-DNSFlush/raw/refs/heads/main/Get-ADC-DNSFlush.ps1")
     ```

2. **Select an action from the menu**:
   - **1. Generate a list of active computers**: Retrieves a list of active computers and saves it to `ActiveComputers.txt`.
   - **2. Flush DNS cache on active computers**: Flushes the DNS cache on computers listed in `ActiveComputers.txt`.
   - **3. Generate a list and flush DNS**: A combined operation — generates a list of active computers and flushes their DNS cache.
   - **4. Exit**: Exits the script.

3. **Logging**:
   - A log file is automatically created in the `C:\ADC-DNSFlush\` directory with a name corresponding to the date and time of execution.
## Example Menu Output
            ==================================================
                            ADC-DNSFlush
            ==================================================
            1. Generate a list of active computers
            2. Flush DNS cache on active computers
            3. Generate a list and flush DNS
            4. Exit
            ==================================================


---
## License
This project is licensed under the MIT License. See the [LICENSE](LICENSE) file for details.


