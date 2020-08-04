FROM nvcr.io/nvidia/l4t-ml:r32.4.3-py3
WORKDIR /

RUN echo 'PS1="\[\033[01;36m\]MEE6\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]\$ "' >> ~/.bashrc  

RUN apt-get update
RUN apt-get install -y gpg python3-pip

RUN pip3 install spacy==2.0.18
RUN pip3 install fastai

#VS Code for ARM
RUN wget -O vscode-arm.sh https://code.headmelted.com/installers/apt.sh
RUN chmod +x ./vscode-arm.sh
RUN ./vscode-arm.sh
RUN rm ./vscode-arm.sh

RUN echo 'alias code="code --user-data-dir /data/haiworking/vscode --extensions-dir /data/haiworking/vscodeexts"' >> ~/.bashrc
#RUN code --user-data-dir /data/haiworking/vscode --install-extension ms-python.python

#DotNet Core ARM manual install
RUN wget https://download.visualstudio.microsoft.com/download/pr/5ee48114-19bf-4a28-89b6-37cab15ec3f2/f5d1f54ca93ceb8be7d8e37029c8e0f2/dotnet-sdk-3.1.302-linux-arm64.tar.gz
RUN mkdir -p "$HOME/dotnet" && tar zxf dotnet-sdk-3.1.302-linux-arm64.tar.gz -C "$HOME/dotnet"
RUN export DOTNET_ROOT=$HOME/dotnet
RUN export PATH=$PATH:$HOME/dotnet
RUN rm ./dotnet-sdk-3.1.302-linux-arm64.tar.gz

RUN echo "export PATH=$PATH:$HOME/dotnet" >> $HOME/.bashrc
RUN echo "export DOTNET_ROOT=$HOME/dotnet" >> $HOME/.bashrc

#Remind about jupyter command line
COPY ./scripts/start-jupyter /usr/bin
RUN echo "echo start-jupyter - starts jupyter lab" >> $HOME/.bashrc

#Node install - packaged version is old
WORKDIR /usr
RUN wget -O- -nv https://nodejs.org/dist/v12.18.3/node-v12.18.3-linux-arm64.tar.xz | xz -d | tar -xv --strip-components=1
WORKDIR /

RUN node -v
RUN npm -v
RUN /root/dotnet/dotnet --version
WORKDIR /nvme/data
ENTRYPOINT ["/bin/bash"]