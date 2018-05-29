
### Prep the sytem with the essentials

```
yum -y update

yum install epel-release

yum -y install make unzip vim autoconf automake ncurses-devel openssl-devel gcc git gcc-c++

yum -y install https://packages.erlang-solutions.com/erlang/esl-erlang/FLAVOUR_1_general/esl-erlang_20.3-1~centos~7_amd64.rpm
```

### Install Elixir 1.6.4 using the asdf package manager 

```
git clone https://github.com/asdf-vm/asdf.git ~/.asdf --branch v0.5.0
cd ~/.asdf/
echo -e '\n. $HOME/.asdf/asdf.sh' >> ~/.bashrc
echo -e '\n. $HOME/.asdf/completions/asdf.bash' >> ~/.bashrc

asdf update
asdf plugin-add erlang
asdf plugin-add elixir
asdf list-all elixir
asdf list-all erlang
asdf install elixir 1.6.4
asdf global elixir 1.6.4
```

### Don't forget you'll need a new shell



```
bash
```

## Optional, configure git to use the public HTTPS URL 

If you don't have a github login, you can just configure git to use the public HTTPS URL

```
git config --global url."https://github.com/".insteadOf git@github.com:
git config --global url."https://".insteadOf git://
```

### Checkout and change into the project directory

```
git clone git@github.com:freeakdb/stockholm_training.git
cd stockholm_training/
```

### Fetch the dependencies, and compile the application 

```
mix deps.get 
mix compile 

```
### Launch the application

```
MIX_ENV=dev iex --name dev@127.0.0.1 -S mix
```
