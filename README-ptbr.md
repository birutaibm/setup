## Avisos iniciais

Em primeiro lugar, deixemos claro que este script foi feito para atender as minhas necessidades. Quem tiver necessidades e preferencias iguais é livre para utilizar os mesmos scripts. Mas como cada pessoa tem suas próprias preferencias, sinta-se a vontade para fazer um fork e adaptar tudo às suas necessidades.

Este script será executado em um Ubuntu 24.04 recém instalado. Dependendo de como está o seu sistema, também podem ser necessários ajustes adicionais.

O diretório `vscode` foi feito segundo as minhas configurações atuais. Consulte a seção `Preparação` para substituir pelos arquivos adequados ao seu caso.

## Preparação

Antes de iniciar a instalação do seu novo Ubuntu, ou a sua migração para o novo computador, você deve copiar suas configurações pessoais do VSCode.
No Ubuntu elas se encontram no diretório `~/.config/Code/User/`. No meu caso copiei apenas o `settings.json` e o diretório de `snippets`, mas você pode copiar tudo que julgar necessário para o diretório `vscode` da sua copia deste projeto, substituindo os meus. Caso queira experimentar com as minhas configurações basta manter o projeto como está.

O arquivo `vscode/extensions.txt` lista as extensões que estou usando no meu vscode, e que serão instaladas no novo sistema. Caso queira montar o mesmo arquivo com as suas use o comando `code --list-extensions > extensions.txt`. Este é um bom momento para você rever suas extensões e remover as que não quer utilizar mais.

Caso você já esteja utilizando o terminal `fish` com o tema `tide` e deseje utilizar as mesmas configurações na nova instalação, execute o script `./export-tide-config.sh` no seu sistema atual copiando a saída para o arquivo `fish/exported-tide-config.txt`. A versão que está neste repositório reflete o que eu estou usando. Caso deseje instalar como está e depois alterar as configurações, você pode utilizar o comando `tide config` no seu novo terminal (após a execução do script e reinicialização do sistema).

## Instruções

- Faça uma cópia desse repositório para seu pendrive
- No diretório onde você salvou, execute `chmod +x *.sh`
- Faça a Preparação conforme descrito na seção anterior
- Leve seu pendrive preparado para a nova máquina
- Com o terminal aberto no diretório desta cópia execute `./dev-setup.sh`
- Reinicie o sistema e teste seu novo ambiente

## Resultado

Ao final do processo você terá o fish configurado como seu terminal padrão, com auto-complete e detecção automática de `.nvmrc` para troca de versão do node, que já estará instalado utilizando o gerenciador asdf.

Docker instalado e pronto para uso, incluindo docker compose.

VSCode instalado e configurado, inclusive com as suas extensões.
