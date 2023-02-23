# Informação importante:
Para utilizar corretamente esse demo, precisa das libs ssl 1.0.2u de acordo com a arquitetura do Windows que for compilar o projeto. Você encontra essas .dlls na pasta CORE\Extras do [pacote principal](https://github.com/OpenSourceCommunityBrasil/REST-DataWare/tree/2.1/CORE/Extras).

1- configure o SSLVersions do ClientREST para TLS 1.2 ou a versão que a API de destino usar como padrão, marque a opção UseSSL, compile o projeto pra gerar o executável.
2- coloque as .dlls `ssleay32.dll` e `libeay32.dll` na mesma pasta que seu executável e rode o projeto que agora vai consumir HTTPS sem erro.