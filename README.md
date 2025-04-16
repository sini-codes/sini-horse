#### Configure SSH
```bash
# Generate key
ssh-keygen -t ed25519 -C "your_email@example.com"

# Start SSH Agent
eval "$(ssh-agent -s)"

# Add key to SSH
ssh-add ~/.ssh/id_ed25519

# Print public key
cat ~/.ssh/id_ed25519.pub
```
Add key on the [Keys](https://github.com/settings/keys) page.

#### Deploy the horse

```bash
cd ~
git clone git@github.com:sini-codes/sini-horse.git
cd sini-horse
chmod +x setup.sh
./setup.sh

# Need to reset shell so new things are pulled in ENV
bash

# Run zellij
zellij -l welcome
```
