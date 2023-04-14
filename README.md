# Crawler APP
![enter image description here](https://res.cloudinary.com/dloadb2bx/image/upload/v1681442700/craw1_k5degk.png)

## Tecnologias utilizadas
![Docker](https://img.shields.io/badge/docker-%230db7ed.svg?style=for-the-badge&logo=docker&logoColor=white)  ![Ruby](https://img.shields.io/badge/ruby-%23CC342D.svg?style=for-the-badge&logo=ruby&logoColor=white) ![Rails](https://img.shields.io/badge/rails-%23CC0000.svg?style=for-the-badge&logo=ruby-on-rails&logoColor=white) ![Postgres](https://img.shields.io/badge/postgres-%23316192.svg?style=for-the-badge&logo=postgresql&logoColor=white) ![Redis](https://img.shields.io/badge/redis-%23DD0031.svg?style=for-the-badge&logo=redis&logoColor=white)

O presente projeto foi desenvolvido utilizando [Docker](https://www.docker.com/), adotando como linguagem de programação o [Ruby on Rails](https://rubyonrails.org/), com o banco de dados [PostgreSQL](https://www.postgresql.org/). Para os background jobs foram utilizados o [Redis](https://redis.io/) e [Sidekiq](https://github.com/sidekiq/sidekiq).  O objetivo final foi criar um MVP, ou seja, um produto minimamente viável que execute uma determinada tarefa pré-definida como prova de conceito. Foram gastas cerca de oito horas de trabalho no projeto.  

### Gems utilizadas que merecem destaque
[Pry](https://github.com/pry/pry):  Para depurar a aplicação. 
[RSpec](https://github.com/rspec/rspec-rails):  Para a realização de testes
[Shoulda-Matchers](https://github.com/thoughtbot/shoulda-matchers): Para integrar nos testes com RSpec
[Simple Form For](https://github.com/heartcombo/simple_form): Geração de formulários mais intuitivos. 
[Nokogiri](https://nokogiri.org/): Utilizado para ler os documentos anexados, realizando o scraping dos dados relevantes.

## Arquivo base
O objetivo do presente projeto é ser capaz de ler um arquivo .eml anexado, ler seu conteúdo filtrando por informações relevantes. O modelo utilizado como base para o código deste projeto foi:
	
`	>> email.eml`
	

    From: "johndoe@test.com" <johndoe@test.com>
    Subject: Meu carro
    To: "sales@sales.com" <sales@sales.com>
    Cc: 
    Bcc: 
    MIME-Version: 1.0
    Content-Type: multipart/alternative;
     boundary="--_=_NextPart5809_c2918dba-0af9-492b-bce0-190936b46673"
    
    This is a multi-part message in MIME format.
    
    ----_=_NextPart5809_c2918dba-0af9-492b-bce0-190936b46673
    Content-Type: text/plain; charset="utf-8"
    Content-Transfer-Encoding: quoted-printable
    
    phone: (31) 3003-4040
    
    name: John Doe
    
    vehicle: BMW 320i
    
    price: 100.000
    
    year: 2022
    
    link: https://mg.olx.com.br/belo-horizonte-e-regiao/autos-e-pecas/carros-vans-e-utilitarios/bmw-320i-2013-2-0-16v-turbo-1171849286?lis=listing_2020
    
    Estou procurando uma BMW 320i na faixa dos 100 a 200 mil.
    
    
    ----_=_NextPart5809_c2918dba-0af9-492b-bce0-190936b46673
    Content-Type: text/html; charset="utf-8"
    Content-Transfer-Encoding: quoted-printable
    
    <meta http-equiv=3D"Content-Type" content=3D"text/html; charset=3Dutf-8"><p=
    >phone: (31) 3003-4040</p><p>name: John Doe</p><p>vehicle: BMW 320i</p>=
    <p>price: 100.000</p><p>year: 2022</p><p>link: https://mg.olx.com.br/belo-horizonte-e-regiao/autos-e-pecas/carros-vans-e-utilitarios/bmw-320i-2013-2-0-16v-turbo-1171849286?lis=listing_2020</p><p>Estou procurando uma BMW 320i na faixa dos 100 a 200 mil.</p><p><br></p>
    ----_=_NextPart5809_c2918dba-0af9-492b-bce0-190936b46673--

## Como funciona o sistema?
Uma vez que um arquivo .eml no formato acima tenha sido anexado na plataforma, o sistema chamará o `leads_controller.rb` que será responsável por receber o arquivo anexado fazendo sua primeira leitura e armazenando seu conteúdo em uma variável. 

Com a variável contendo os dados crus do arquivo anexado o job `LeadGenerator.job` é chamado, sendo responsável pelo tratamento dos dados em background. Neste job, um Lead será criado e os dados serão raspados pela primeira vez, com o objetivo de se buscar o telefone, nome, veículo, preço, ano e link de um anúncio recebido e armazenado no arquivo anexado. 

Tendo sido criado o `leads_controller.rb`retornará com os dados e agora verificará os Leads existentes e se este possui um veículo vinculado a ele, não existindo o `VehicleGeneratorJob` é chamado, iniciando um segundo trabalho em background que receberá o link armazenado na etapa de scraping do Lead, e então acessará a página web em busca das informações necessárias. 

No caso em tela, foi utilizado um link do OLX escolhido aleatoriamente e disponível na data de 13 de abril de 2023.

[Clique aqui](https://mg.olx.com.br/belo-horizonte-e-regiao/autos-e-pecas/carros-vans-e-utilitarios/bmw-320i-2013-2-0-16v-turbo-1171849286?lis=listing_2020) para abrir o link do OLX (obs: o link poderá ficar indisponível). Abaixo é possível ver os dados que foram buscados da referida página web.
<br>
![enter image description here](https://res.cloudinary.com/dloadb2bx/image/upload/v1681407640/scrap1_xadsj0.png)

Ao realizar o scraping da página acima, os dados como modelo, marca, quilometragem e os itens opcionais são recebidos pelo `VehicleGeneratorJob` que fica responsável por instanciar um novo veículo vinculado a um Lead já cadastrado cujo link foi objetivo em seu scraping, bem como instancia seus itens opcionais. 

## Interface
Não foi utilizada nenhum recurso para a criação de interfaces complexas dado a simplicidade do frontend, resumindo ao desenvolvimento básico com CSS. 

Foi desenvolvida duas telas simples, a primeira e definida como "root" do projeto permite o upload de um arquivo ".eml". Uma vez anexado e tendo os dados sidos extraídos, o usuário é enviado para o dashboard onde pode ver os últimos resultados obtidos. 
![enter image description here](https://res.cloudinary.com/dloadb2bx/image/upload/v1681443979/craw3_pzhr6q.png)

Não foi implementada a funcionalidade de login com Devise tampouco "policies" de autorização com Pundit, uma vez que o objetivo era realizar o processo de obtenção de dados de arquivos e páginas web. A implementação de autenticação pode ser visto em projetos como [Real State API](https://github.com/thiagohrcosta/tourist-app-API) e autorização no [Restaurants With Pundit](https://github.com/thiagohrcosta/restaurants_with_pundit)

## .Env keys
Para a execução correta do projeto, será necessário adicionar um arquivo .env com as seguintes chaves:

    REDIS_URL_SIDEKIQ=redis://redis:6379/1
    REDIS_HOST=redis
   
   Lembre-se de adicionar no .gitignore o arquivo .env. 
<br>
## Como rodar o projeto?
Este projeto roda com Docker. O arquivo `docker-compose.yml`, contém todas as informações dos containers que irão subir com a aplicação, neste caso:

    Banco de dados PostgreSQL
    Redis
    Sidekiq
    Web (a aplicação)

Faça o clone do projeto , acesse a pasta e rode o comando `docker-compose build` para que sejam rodados todos os comandos necessários tais como bundle install, yarn install, entre outros. Ao final, concluído o comando anterior rode o comando `docker-compose up` para subir a aplicação.

Caso decida efetuar testes ("*debugar*") em tempo real na aplicação com o `pry`, suba a aplicação com o comando `docker-compose run --service-ports web`. 

## Comandos importantes com Docker
**Acessar o terminal do rails:** docker-compose run web rails c <br>
**Listar rotas**: docker-compose run web rails routes -c "nome do controller" <br>
**Iniciar o projeto e containers**: docker-compose build <br>
**Subir a aplicação**: docker-compose up <br>


## Referências em meus repositórios no Github

**BackgroundJobs**<br>
[Sidekiq-background](https://github.com/thiagohrcosta/Sidekiq-background): Pequeno projeto testando e implementando background jobs.

**Scraping**<br>
[Viaggiare-Italia-API](https://github.com/thiagohrcosta/Viaggiare-Italia-API): Neste projeto foi realizado um scraping de dados públicos de cidades italianas e de repositórios de fotos no Unsplash. [Clique aqui](https://github.com/thiagohrcosta/Viaggiare-Italia-API/blob/main/db/seeds.rb) para visualizar. 
[Scraper Ruby](https://github.com/thiagohrcosta/scraper-ruby): Pequeno projeto para testar o Nokogiri.

**Mailing**<br>
[Ruby Mailing](https://github.com/thiagohrcosta/Mailing): Projeto desenvolvido para testar a utilização do sistema de mailing com RoR.

**Testes**<br>
[E-Commerce-API](https://github.com/thiagohrcosta/Ecommerce-Api): Aplicação desenvolvida com mais de 200 testes, inclusive de requests. 

**Frontend**<br>
[Coffee Delivery](https://github.com/thiagohrcosta/Coffee-delivery): Aplicação de delivery desenvolvido com Styled Components.
