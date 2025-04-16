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
git clone https://github.com/sini-codes/sini-horse
cd sini-horse
chmod +x setup.sh
./setup.sh
```
