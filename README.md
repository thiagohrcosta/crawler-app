# Crawler APP

## Tecnologias utilizadas
![Docker](https://img.shields.io/badge/docker-%230db7ed.svg?style=for-the-badge&logo=docker&logoColor=white)  ![Ruby](https://img.shields.io/badge/ruby-%23CC342D.svg?style=for-the-badge&logo=ruby&logoColor=white) ![Rails](https://img.shields.io/badge/rails-%23CC0000.svg?style=for-the-badge&logo=ruby-on-rails&logoColor=white) ![Postgres](https://img.shields.io/badge/postgres-%23316192.svg?style=for-the-badge&logo=postgresql&logoColor=white) ![Redis](https://img.shields.io/badge/redis-%23DD0031.svg?style=for-the-badge&logo=redis&logoColor=white)

O presente projeto foi desenvolvido utilizando [Docker](https://www.docker.com/), adotando como linguagem de programação o [Ruby on Rails](https://rubyonrails.org/), com o banco de dados [PostgreSQL](https://www.postgresql.org/). Para os background jobs foram utilizados o [Redis](https://redis.io/) e [Sidekiq](https://github.com/sidekiq/sidekiq). 

### Gems utilizadas que merecem destaque
[Pry](https://github.com/pry/pry):  Para depurar a aplicação. 
[RSpec](https://github.com/rspec/rspec-rails):  Para a realização de testes
[Shoulda-Matchers](https://github.com/thoughtbot/shoulda-matchers): Para integrar nos testes com RSpec
[Simple Form For](https://github.com/heartcombo/simple_form): Geração de formulários mais intuitivos. 
[Nokogiri](https://nokogiri.org/): Utilizado para ler os documentos anexados, realizando o scraping dos dados relevantes.

## Arquivo base
O objetivo do presente projeto é ser capaz de ler um arquivo .eml anexado, ler seu conteúdo filtrando por informações relevantes. O modelo utilizado como base para o código deste projeto foi:
	
`	>> email.eml`
	

    From: "johndoe@test.com" <thiago@test.com>
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
    >phone: (31) 3003-4040</p><p>name: Thiago Costa</p><p>vehicle: BMW 320i</p>=
    <p>price: 100.000</p><p>year: 2022</p><p>link: https://mg.olx.com.br/belo-horizonte-e-regiao/autos-e-pecas/carros-vans-e-utilitarios/bmw-320i-2013-2-0-16v-turbo-1171849286?lis=listing_2020</p><p>Es=
    tou procurando uma BMW 320i na faixa dos 100 a 200 mil=2E&nbsp;</p><p><br><=
    /p>
    ----_=_NextPart5809_c2918dba-0af9-492b-bce0-190936b46673--

## Como funciona o sistema?
Uma vez que um arquivo .eml no formato acima tenha sido anexado na plataforma, o sistema chamará o `leads_controller.rb` que será responsável por receber o arquivo anexado fazendo sua primeira leitura e armazenando seu conteúdo em uma variável. 

Com a variável contendo os dados crus do arquivo anexado o job `LeadGenerator.job` é chamado, sendo responsável pelo tratamento dos dados em background. Neste job, um Lead será criado e os dados serão raspados pela primeira vez, com o objetivo de se buscar o telefone, nome, veículo, preço, ano e link de um anúncio recebido e armazenado no arquivo anexado. 

Tendo sido criado o `leads_controller.rb`retornará com os dados e agora verificará os Leads existentes e se este possui um veículo vinculado a ele, não existindo o `VehicleGeneratorJob` é chamado, iniciando um segundo trabalho em background que receberá o link armazenado na etapa de scraping do Lead, e então acessará a página web em busca das informações necessárias. 

No caso em tela, foi utilizado um link do OLX escolhido aleatoriamente e disponível na data de 13 de abril de 2023.

[Clique aqui](https://mg.olx.com.br/belo-horizonte-e-regiao/autos-e-pecas/carros-vans-e-utilitarios/bmw-320i-2013-2-0-16v-turbo-1171849286?lis=listing_2020) para abrir o link do OLX (obs: o link poderá ficar indisponível). Abaixo é possível ver os dados que foram buscados da referida página web.
![enter image description here](https://res.cloudinary.com/dloadb2bx/image/upload/v1681407640/scrap1_xadsj0.png)

Ao realizar o scraping da página acima, os dados como modelo, marca, quilometragem e os itens opcionais são recebidos pelo VehicleGeneratorJob que fica responsável por instanciar um novo veículo vinculado a um Lead já cadastrado cujo link foi objetivo em seu scraping, bem como instancia seus itens opcionais. 