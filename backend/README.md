# RESTful API
## Install Dotnet Framework:
Get newest Version: \
  ```curl -sSL https://dot.net/v1/dotnet-install.sh | bash /dev/stdin --channel STS``` \
Update System Variables: \
  ```echo 'export DOTNET_ROOT=$HOME/.dotnet' >> ~/.bashrc``` \
  ```echo 'export PATH=$PATH:$HOME/.dotnet' >> ~/.bashrc``` \
  ```source ~/.bashrc``` \
Verify .NET Installation: \
  ```dotnet --version``` \
## Get newest API-Version:
Clone Repository: \
 ```git clone -b backend --single-branch https://github.com/gio3000/SWEeng21``` \
or if already cloned pull newest version: \
  ```git pull```
## Run the API:
```dotnet run --project ~/SWEeng21/RESTful\ API```
