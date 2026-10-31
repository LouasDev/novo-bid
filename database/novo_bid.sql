CREATE DATABASE IF NOT EXISTS novo_bid CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
USE novo_bid;

CREATE TABLE usuarios (id INT PRIMARY KEY AUTO_INCREMENT, nome VARCHAR(100) NOT NULL, email VARCHAR(120) NOT NULL UNIQUE, senha VARCHAR(255) NOT NULL, perfil ENUM('Administrador','Analista') NOT NULL DEFAULT 'Analista', ativo BOOLEAN NOT NULL DEFAULT TRUE, criado_em TIMESTAMP DEFAULT CURRENT_TIMESTAMP);
CREATE TABLE orgaos (id INT PRIMARY KEY AUTO_INCREMENT, nome VARCHAR(160) NOT NULL, cnpj VARCHAR(18) NOT NULL UNIQUE, cidade VARCHAR(100), uf CHAR(2), contato VARCHAR(100), email VARCHAR(120), criado_em TIMESTAMP DEFAULT CURRENT_TIMESTAMP);
CREATE TABLE medicamentos (id INT PRIMARY KEY AUTO_INCREMENT, nome VARCHAR(150) NOT NULL, principio_ativo VARCHAR(150) NOT NULL, apresentacao VARCHAR(150), registro_anvisa VARCHAR(50) UNIQUE, estoque INT NOT NULL DEFAULT 0, validade DATE, criado_em TIMESTAMP DEFAULT CURRENT_TIMESTAMP);
CREATE TABLE responsaveis (id INT PRIMARY KEY AUTO_INCREMENT, nome VARCHAR(120) NOT NULL, cargo VARCHAR(100), telefone VARCHAR(20), email VARCHAR(120), criado_em TIMESTAMP DEFAULT CURRENT_TIMESTAMP);
CREATE TABLE licitacoes (id INT PRIMARY KEY AUTO_INCREMENT, numero VARCHAR(50) NOT NULL UNIQUE, orgao_id INT NOT NULL, medicamento_id INT NOT NULL, responsavel_id INT, prazo_proposta DATE NOT NULL, quantidade INT NOT NULL, valor_estimado DECIMAL(14,2), status ENUM('Rascunho','Edital aberto','Proposta enviada','Em análise','Aprovada','Em entrega','Concluída','Cancelada') NOT NULL DEFAULT 'Edital aberto', observacoes TEXT, criado_em TIMESTAMP DEFAULT CURRENT_TIMESTAMP, FOREIGN KEY (orgao_id) REFERENCES orgaos(id), FOREIGN KEY (medicamento_id) REFERENCES medicamentos(id), FOREIGN KEY (responsavel_id) REFERENCES responsaveis(id));
CREATE TABLE contratos (id INT PRIMARY KEY AUTO_INCREMENT, numero VARCHAR(50) NOT NULL UNIQUE, licitacao_id INT NOT NULL UNIQUE, valor_contratado DECIMAL(14,2), prazo_entrega DATE NOT NULL, status ENUM('Ativo','Em entrega','Concluído','Cancelado') NOT NULL DEFAULT 'Ativo', criado_em TIMESTAMP DEFAULT CURRENT_TIMESTAMP, FOREIGN KEY (licitacao_id) REFERENCES licitacoes(id));

INSERT INTO orgaos (nome,cnpj,cidade,uf,contato,email) VALUES
('Secretaria Municipal de Saúde de Belo Horizonte','18.715.383/0001-40','Belo Horizonte','MG','Ana Beatriz','compras.saude@exemplo.gov.br'),
('Hospital Regional do Norte','23.584.917/0001-09','Montes Claros','MG','Carlos Henrique','licitacoes@hrn.exemplo.br'),
('Prefeitura Municipal de Uberlândia','18.431.312/0001-15','Uberlândia','MG','Mariana Costa','saude@uberlandia.exemplo.gov.br');
INSERT INTO medicamentos (nome,principio_ativo,apresentacao,registro_anvisa,estoque,validade) VALUES
('Insulina Humana','Insulina humana regular','Frasco-ampola 10 mL','102160258',840,'2027-08-30'),
('Semaglutida','Semaglutida','Caneta injetável 0,25 mg','102160301',320,'2027-02-28'),
('Somatropina','Somatropina','Caneta injetável 12 mg','102160412',112,'2026-12-31');
INSERT INTO responsaveis (nome,cargo,telefone,email) VALUES
('Renata Oliveira','Analista de licitações','(31) 98888-1101','renata.oliveira@novobid.com'),
('Lucas Ferreira','Gerente comercial','(31) 98888-1102','lucas.ferreira@novobid.com');
INSERT INTO licitacoes (numero,orgao_id,medicamento_id,responsavel_id,prazo_proposta,quantidade,valor_estimado,status,observacoes) VALUES
('PE-2026/0148',1,1,1,DATE_ADD(CURDATE(),INTERVAL 4 DAY),1200,185000.00,'Edital aberto','Aquisição para a rede municipal.'),
('PE-2026/0217',2,2,2,DATE_ADD(CURDATE(),INTERVAL 9 DAY),480,298000.00,'Em análise','Documentação enviada.'),
('PE-2026/0203',3,3,1,DATE_ADD(CURDATE(),INTERVAL 16 DAY),200,163000.00,'Proposta enviada','Aguardando sessão pública.');
INSERT INTO contratos (numero,licitacao_id,valor_contratado,prazo_entrega,status) VALUES
('CT-2026/0081',2,284500.00,DATE_ADD(CURDATE(),INTERVAL 25 DAY),'Ativo');
