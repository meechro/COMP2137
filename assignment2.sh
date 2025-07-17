#!/bin/bash

# This is a script that will update system information such as netplan ip, install software
# and add users to groups.
hostname=$(hostname)
host_file="/etc/hosts"

netplan=$(ls /etc/netplan/*.yaml | sort | tail -n1)

if [ -z "$netplan" ]; then
  echo "Cannot find Netplan config file in /etc/netplan"
  exit 1
fi

echo "Using netplan config file: $netplan"

newip="192.168.16.21/24"
correct_ip="192.168.16.21"
interface=$(ip r s default | awk '{print $5}')
findip=$(ip a s "$interface" | awk '/inet / {print $2}' | head -n1)
#finds system ip without the suffix
findip_clean=$(echo "$findip" | cut -d'/' -f1)

lineforhost="$correct_ip $hostname"

if grep -q "$newip" "$netplan"; then
  echo "Updated IP is already configured in Netplan"
else
  echo "Updating.."
  sed -i "s|$findip|$newip|" "$netplan"
  netplan apply
  echo "Netplan file updated!"
fi


# Updating /etc/hosts file
if grep -q "$lineforhost" "$host_file"; then
  echo "/etc/hosts has the correct ip!"
else
  
  # Remove any existing line with the hostname before adding new one
  sed -i "/ $hostname/d" "$host_file"
  
    # Append the new line
    echo "$lineforhost" >> "$host_file"

fi
  
#Check if Apache2 is installed, and if not, install it.

if dpkg -l | grep -q apache2; then
  echo "Apache2 is installed on your machine."
else
  echo "Installing Apache2..."
  apt-get update && apt-get install -y apache2
  echo "Apache2 is now installed"
fi

#Check if squid is installed, if not, install it.

if dpkg -l | grep -q squid; then
  echo "Squid is installed on your machine."
else
  echo "Installing Squid..."
  apt-get update && apt-get install -y squid
  echo "Squid is now installed"
  
fi


echo "------------------------------"
echo " Creating Users and SSH Keys! "
echo "------------------------------"

#List of Usernames
users=(dennis aubrey captain snibbles brownie scooter sandy perrier cindy tiger yoda)

for user in "${users[@]}"; do
  echo ""
  echo "Processing user: $user"
  
  # Create user if they don't exist
  # Checks if user exists, if so id returns 0
  #If not then the output gets discared by &>/dev/null
  if id "$user" &>/dev/null; then
    echo "User $user already exists."
  else
    echo "Creating user $user..."
    useradd -m -s /bin/bash "$user"
  fi
  
  # create .ssh directory
  mkdir -p /home/"$user"/.ssh
  chmod 700 /home/"$user"/.ssh
  
  # ASK FOR HELP ON THIS PART!!!!
  # ASK FOR HELP ON THIS PART!!!!
  # generate RSA key if not there
  if [ ! -f /home/"$user"/.ssh/id_rsa ]; then
    ssh-keygen -t rsa -b 2048 -f /home/"$user"/.ssh/id_rsa -N ""
  fi

  # generate ED25519 key if not there
  if [ ! -f /home/"$user"/.ssh/id_ed25519 ]; then
    ssh-keygen -t ed25519 -f /home/"$user"/.ssh/id_ed25519 -N ""
  fi
  
  # Ensure authorized_keys file exists
  touch /home/"$user"/.ssh/authorized_keys

  # Add RSA public key if not already in authorized_keys
  grep -q -F "$(cat /home/"$user"/.ssh/id_rsa.pub)" /home/"$user"/.ssh/authorized_keys || \
  cat /home/"$user"/.ssh/id_rsa.pub >> /home/"$user"/.ssh/authorized_keys

  # Add ED25519 public key if not already in authorized_keys
  grep -q -F "$(cat /home/"$user"/.ssh/id_ed25519.pub)" /home/"$user"/.ssh/authorized_keys || \
  cat /home/"$user"/.ssh/id_ed25519.pub >> /home/"$user"/.ssh/authorized_keys

 # ASK FOR HELP ON THIS!!!!!!!!
 
  # add extra key and sudo for user dennis
  if [ "$user" == "dennis" ]; then
    echo "Adding instructor SSH key for dennis..."
    echo "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIG4rT3vTt99Ox5kndS4HmgTrKBT8SKzhK4rhGkEVGlCI" >> /home/dennis/.ssh/authorized_keys
    usermod -aG sudo dennis
  fi  
  
    # Set permissions and ownership
  chmod 600 /home/"$user"/.ssh/authorized_keys
  chown -R "$user":"$user" /home/"$user"/.ssh
done

echo "---- User creation complete ----"
