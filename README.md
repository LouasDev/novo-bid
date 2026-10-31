# NovoBid

Projeto acadêmico fictício de gestão de licitações e fornecimento institucional de medicamentos. Não possui vínculo oficial com a Novo Nordisk.

## Recursos

- Login com perfis Administrador e Analista
- Cadastro de órgãos compradores, medicamentos e responsáveis
- Gestão de licitações, contratos e prazos de entrega
- Dashboard operacional e agenda mensal de prazos
- Pesquisa, edição e exclusão restrita ao Administrador
- Interface responsiva com fonte Poppins e identidade visual inspirada na logo fornecida

## Tecnologias

HTML, CSS, JavaScript, Node.js, Express, MySQL, JWT e bcryptjs.

## Como executar

1. Importe `database/novo_bid.sql` no phpMyAdmin.
2. Ajuste o arquivo `.env` com os dados do MySQL. O padrão usa o banco `novo_bid`.
3. Execute `npm start`.
4. Abra `http://localhost:3000`.

## Acesso de demonstração

- Administrador: `admin@novobid.com`
- Analista: `analista@novobid.com`
- Senha: `123456`
