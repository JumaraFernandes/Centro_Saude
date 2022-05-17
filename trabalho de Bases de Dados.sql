create database CentroSaude; --criação da base de dados
use CentroSaude;
--criação das tabelas
create table Pessoa(
BI varchar(15) not null primary key(BI),--chave primaria
Datanascimento date not null,
nome varchar(20) not null,
morada varchar(40) not null,
email varchar(25) not null,
telefone int not null,
statusPessoa varchar(20) not null,
sexo char(1) not null check(sexo in('M','F')));
--o sexo pode ser Masculino ou Feminino

create table Funcionario(
codigofun int not null primary key(codigofun) identity(1,1) ,--chave primaria e autoincremente
cargo varchar(15) not  null,
BI varchar(15) not null references Pessoa(BI),
salario money not null,
estado char(1)not null check(estado in ('C','F','R','D')) default'C');
--vai dizer o estado do funcionario se foi contratado, se foi de ferias,
--ou reformado,ou Demitido

create table Reformado(
codigofun int not null primary key(codigofun)  references Funcionario ,
cargo varchar(15) not  null,
BI varchar(15) not null references Pessoa(BI),--chave estrangeira 
salario money not null);

create table  Especialidade(descricao varchar(40) not null primary key(descricao));

create table Medico(
numeroRegisto int not null primary key(numeroRegisto) identity(1,1),
codigofun int not null  references  Funcionario(codigofun) unique(codigofun),
--a tabele Medico se relaciona com a tabela pessoa através do codigo do funcionario que é unico para cada funcionario
especialidade varchar(40) not null references Especialidade(descricao));


create table Utente(
numeroUtente int not null primary key (numeroUtente) identity(1,1),
medicofamilia int not null references Medico(numeroRegisto),
--a tabela Utente se relaciona com a tabela medico atraves do campo numero Registo
BI VARCHAR(15) not null references Pessoa(BI) unique(BI),
nomecentroSaúde varchar(45) not null,--vai dizer o nome do centro saúde que pertence
estado char(1) not null check(estado in('T','N')));--vai dizer o estado do utente se foi transfererido ou não

create table TransferirUtente(
numeroUtente int not null primary key(numeroUtente) references Utente(numeroUtente),
BI Varchar(15) not null,
nome varchar(20) not null,
morada varchar(40) not null,
email varchar(25) not null,
telefone int not null,
nomecentroSaúde varchar(45) not null,--vai dizer o nome do centro saúde que pertence
sexo char(1) not null check(sexo in('M','F')));



create table Admistrador(
codigofun int not null  primary key (codigofun)references  Funcionario(codigofun));

create table TipoConsulta(
descricao varchar(45) not null  primary key(descricao));

create table Consulta(
codigoConsulta int not null primary key(codigoConsulta) identity(1,1),
tipoconsulta varchar(45) not null references TipoConsulta(descricao),
codigoMedico int not null references Medico(numeroRegisto),
utente int not null references Utente(numeroUtente),
data datetime not null);
 
 create table TipoExame(
nome varchar(25) not null  primary key(nome));

create table Exame(
codigoExame int not null primary Key(codigoExame) identity(1,1),
nome varchar(25) not null references TipoExame(nome),
data datetime  not null,
codigoConsulta int not null references Consulta(codigoConsulta),
diagnostico varchar(50) );

create table Enfermeiro(
numeroRegisto int not null primary key(numeroRegisto) identity(1,1),
codigoFun int not null references Funcionario(codigoFun)unique(codigofun));


create table Doenca(iddoenca int not null primary key(iddoenca),
nome varchar(25) not null,
descricao varchar(30) not null,
tipo varchar(25) not null,
numeroUtente int not null references Utente);

create table HistoricoExame(
numeroUtente int not null references TransferirUtente(numeroUtente),
codigoExame int not null ,
nome varchar(25) not null ,
data datetime  not null,
codigoConsulta int not null ,
diagnostico varchar(50) );

create table HistoricoDoenca(
numeroUtente int not null  references  TransferirUtente(numeroUtente),
nome varchar(25) not null,
descricao varchar(30) not null,
tipo varchar(25) not null);

 create table HistoricoConsultas(
 codigoConsulta int not null ,
tipoconsulta varchar(45) not null ,
Medico Varchar(30) not null ,
utente int not null references TransferirUtente(numeroUtente),
data datetime not null);


create table Vacina(
numeroVacina int primary key(numeroVacina)  identity(1,1),
lote varchar(30) ,
utente int not null references Utente(numeroUtente),
tipovacina varchar(20) not null ,
data datetime ,
local varchar(30) ,
certificado bit default 0);




--procedure para adicionar uma Pessoa
create PROCEDURE [adicinarPessoa](@BI char(15),
 @nome varchar(20),@morada varchar(40), @email varchar(25), @telefone int, 
 @statusPessoa varchar(20),@sexo char(1),@datanascimento date) AS
IF NOT EXISTS(SELECT @BI FROM Pessoa  WHERE BI = @BI)
begin
	INSERT INTO Pessoa
	(BI,nome, morada,email,telefone,statusPessoa,sexo,datanascimento)
	Values
	(@BI,@nome,@morada,@email,@telefone,@statusPessoa,@sexo,@datanascimento) 
END


 exec adicinarPessoa 'a4355', 'Jumara' ,'Lisboa','jumaraandradade@gmail.com',960102287,'viva','M','1997-09-03';

--procecdure para Registar Funcionario
create PROCEDURE [RegistarFuncionario](@BI char(15),@nome varchar(20),@morada varchar(40), 
@email varchar(25), @telefone int, @statusPessoa varchar(20),@sexo char(1),@datanascimento date,
@cargo varchar(15),@estado char(1),@salario money) As
exec adicinarPessoa @BI,@nome,@morada,@email,@telefone,@statusPessoa,@sexo,@datanascimento;
IF NOT EXISTS(SELECT BI FROM Funcionario WHERE BI = @BI)
begin
	INSERT INTO Funcionario Values(@cargo,@BI, @salario,@estado);
end

exec RegistarFuncionario 'a46398', 'Redney', 'Largo Pedro Alvares Cabral', 'a46398@alunos.ipb.pt', 931318479, 'viva', 'M', '2000-12-01','Administrador', 'C',12233;
exec RegistarFuncionario 'a46392', 'Red', 'Largo Pedro Alvares Cabral', 'a46398@alunos.ipb.pt', 931318409, 'viva', 'M', '2000-12-01','Administrador', 'C',12233;
exec RegistarFuncionario 'a46393', 'dney', 'Largo Pedro Alvares Cabral', 'a46398@alunos.ipb.pt', 931318475, 'viva', 'M', '2000-12-01','Administrador', 'C',12233;
exec RegistarFuncionario 'a46394', 'edne', 'Largo Pedro Alvares Cabral', 'a46398@alunos.ipb.pt', 931318470, 'viva', 'M', '2000-12-01','Administrador', 'C',362233;
exec RegistarFuncionario 'a46395', 'ney', 'Largo Pedro Alvares Cabral', 'a46398@alunos.ipb.pt', 931318476, 'viva', 'M', '2000-12-01','Administrador', 'C',92233;
exec RegistarFuncionario 'a46396', 'Rney', 'Largo Pedro Alvares Cabral', 'a46398@alunos.ipb.pt', 931318473, 'viva', 'M', '1940-12-01','Administrador', 'C',33233;
exec RegistarFuncionario 'a4err', 'cisa', 'Largo Pedro Alvares Cabral', 'a46398@alunos.ipb.pt', 931318471, 'viva', 'F', '19490-12-01','Administrador', 'C',362233;
exec RegistarFuncionario 'a4355', 'bruney', 'Largo Pedro Alvares Cabral', 'a46398@alunos.ipb.pt', 931318482, 'viva', 'F', '1950-12-01','Administrador', 'C',362233;

--procedure para atualizarFuncionario
create procedure AtualizarFuncionario(@morada varchar(40), 
@email varchar(25), @telefone int,@cargo varchar(15),@estado char(1),@codigofun int,@salario money)  as
  update Pessoa
  set morada=@morada,
  email=@email,
  telefone=@telefone
  where  Pessoa.BI=(select BI from Funcionario where codigofun=@codigofun) 
  update Funcionario 
 set cargo=@cargo,
  estado=@estado,
  salario=@salario
  where  codigofun=@codigofun;

  exec AtualizarFuncionario 'rua Maria Alves Esteves','maurafernandes@gmail.com',963278561,'Medica','C',2,4500;
   --procedure para AdicionarEspecialidade
  create procedure [AdicionarEspecialidade] (@descrição varchar(40)) as
  insert into Especialidade values (@descrição);
  exec AdicionarEspecialidade 'Anestesiologia';
  exec AdicionarEspecialidade 'Cardiologia';
  exec AdicionarEspecialidade 'gineconologista';
  exec AdicionarEspecialidade 'Cirurgia Geral';
  exec AdicionarEspecialidade 'Estomatologia';
  exec AdicionarEspecialidade 'Doenças Infecciosas';
  exec AdicionarEspecialidade 'Endocrinologia-Nutrição';
  exec AdicionarEspecialidade 'Farmacologia Clínica';
  exec AdicionarEspecialidade 'Gastrenterologia';
  exec AdicionarEspecialidade 'Cirurgia Plástica e Reconstrutiva e Estética';
  exec AdicionarEspecialidade 'Cirurgia Cardio-Torácica';

   --procedure para Registar Medico
 create procedure [RegistarMedico](@BI char(15),@nome varchar(20),@morada varchar(40), 
@email varchar(25), @telefone int, @statusPessoa varchar(20),@sexo char(1),@datanascimento date,
@cargo varchar(15),@estado char(1),@salario money ,@especialidade varchar(40)) As
exec RegistarFuncionario @BI,@nome,@morada,@email,@telefone,@statusPessoa,@sexo,@datanascimento,@cargo,@estado,@salario;
INSERT INTO Medico
Values
((select codigofun from Funcionario Where Funcionario.BI =@BI),@especialidade);

exec RegistarMedico 'b8943','Jumara','Mirandela ','jumaraandrade@gmail.com',94513456,'viva','F','2000-12-05','Medica','C',2233,'Estomatologia';
exec RegistarMedico 'a2455','leo','Bragança rua vale','leosantanagmail',960102220,'viva','M','1900-03-03','Medico','C', 100,'gineconologista';
exec RegistarMedico 'p6223','Marcia','vila real','jumaraandrade@gmail.com',94713456,'viva','F','1953-03-23','Medica','C', 2300,'Anestesiologia';
exec RegistarMedico 'l2648','Daia','Brga ','jumaraandrade@gmail.com',94513491,'viva','F','1983-03-23','Medica','C',1300,'Cardiologia';
exec RegistarMedico 'k3846','Manuel','cacem ','jumaraandrade@gmail.com',94513445,'viva','M','1957-01-04','Medico','C',1300,'Cirurgia Geral';
exec RegistarMedico 'j6423','Wilson','lanranjerio ','jumaraandrade@gmail.com',94556456,'viva','M','1999-03-04','Medico','C',3500,'Doenças Infecciosas';
exec RegistarMedico 'h0375','Fernanda','Barreiro','fenandaandrade@gmail.com',92313456,'viva','F','1989-04-08','Medica','C',8500,'Endocrinologia-Nutrição';
exec RegistarMedico 'g1448','Carla','Fogueteiro ','carlaandrade@gmail.com',94513474,'viva','F','1982-09-04','Medica','C',4900,'Farmacologia Clínica';
exec RegistarMedico 'f2945','Joel','Algarve ','joelandrade@gmail.com',94513490,'viva','M','1952-02-07','Medico','C',6300,'Gastrenterologia';
exec RegistarMedico 'd50240','Nico','Guarda ','nicoandrade@gmail.com',94518756,'viva','M','1993-02-04','Medico','C',7300,'Cirurgia Plástica e Reconstrutiva e Estética';
exec RegistarMedico 'c30242','Gil','Nazare ','Gilaandrade@gmail.com',97934567,'viva','M','1993-04-06','Medico','C',4300,'Cirurgia Cardio-Torácica';


 --Procedure para Registar um Enfermeiro
 create procedure [RegistarEnfermeiro](@BI char(15),@nome varchar(20),@morada varchar(40), 
@email varchar(25), @telefone int, @statusPessoa varchar(20),@sexo char(1),@cargo varchar(15),@estado char(1),@datanascimento date,
@salario money) As
exec RegistarFuncionario @BI,@nome,@morada,@email,@telefone,@statusPessoa,@sexo,@datanascimento,@cargo,@estado,@salario;
INSERT INTO Enfermeiro values
((select codigofun from Funcionario Where Funcionario.BI =@BI));

exec RegistarEnfermeiro 'ab4567','Nadiney','Lisboa rua quintela','nadineysantana@gmail.com',932891294,'viva','F','Enfermeira','C','1992-05-25',2300;
exec RegistarEnfermeiro 'ab45655','Quinina','Lisboa rua quintela','nadineysantana@gmail.com',932891634,'viva','F','Enfermeira','C','1892-05-25',600;
exec RegistarEnfermeiro 'ab45777','Jossy','Lisboa rua quintela','nadineysantana@gmail.com',932891834,'viva','F','Enfermeira','C','1992-05-25',7300;
exec RegistarEnfermeiro 'ab45777','sffg','Lisboa rua quintela','ndineysantana@gmail.com',932893434,'viva','F','Enfermeira','C','1992-05-25',2300;
exec RegistarEnfermeiro 'ab44677','Nadiney','Lisboa rua quintela','rtdineysantana@gmail.com',932890934,'viva','F','Enfermeira','C','1972-05-25',1000;
exec RegistarEnfermeiro 'ab4ett7','Nad','Lisboa rua quintela','tyydineysantana@gmail.com',932891434,'viva','M','Enfermeiro','C','1972-05-25',2400;
exec RegistarEnfermeiro 'ab4er7','kariney','Lisboa rua quintela','uyineysantana@gmail.com',932891534,'viva','M','Enfermeiro','C','1952-05-25',2100;
exec RegistarEnfermeiro 'ab45645','sfney','Lisboa rua quintela','nwwineysantana@gmail.com',932891634,'viva','M','Enfermeiro','C','1982-05-25',800;
exec RegistarEnfermeiro 'ab45612','sney','Lisboa rua quintela','nyttineysantana@gmail.com',932891834,'viva','M','Enfermeiro','C','1990-05-25',2600; 

exec RegistarEnfermeiro 'gerfg','sfney','Lisboa rua quintela','nwwineysantana@gmail.com',932891634,'viva','M','Enfermeiro','C','1982-05-25',800;

create table InsertedNumero(numero int not null);

-- adicionar reformado
CREATE PROCEDURE [AdicionarReformado](@codigofun int ,@cargo varchar(15),@BI varchar(15),@salario money)as
 IF NOT EXISTS(SELECT codigofun FROM Reformado WHERE codigofun = @codigofun)
  begin
  insert into InsertedNumero(numero) values(@codigofun)
INSERT INTO Reformado
Values
(@codigofun,@cargo,@BI,@salario);
delete from InsertedNumero;
end
exec AdicionarReformado  3, 'Medico', 'a2455', 100;
exec AdicionarReformado  1, 'Medico', 'a2455', 12233;

--verifca se existe um medico que não esteja relacionado com nenhum utente, se exitir relaciona este medico ao utente,
--senão vai verificar qual é o medico com menor numero de utente relacionado e associa a este utente

--procedure para adicionar um Utente adicionarUTente
create procedure [adicionarUtente]( @BI char(15),
 @nome varchar(20),@morada varchar(40), @email varchar(25), @telefone int, @statusPessoa varchar(20),
 @sexo char(1),@datanascimento date,@nomecentrosaúde varchar(45),@estado char(1)) as
exec adicinarPessoa @BI,@nome,@morada,@email,@telefone,@statusPessoa,@sexo,@datanascimento ;
if exists (select top(1) numeroRegisto from Medico where Medico.numeroRegisto not in (select medicofamilia from Utente))
begin 
insert into Utente values ((select top(1) numeroRegisto from Medico where Medico.numeroRegisto not in (select medicofamilia from Utente)), @BI,@nomecentrosaúde,@estado)
end
else 
begin
insert into Utente values ((select top(1) medicofamilia from Utente group by medicofamilia order by medicofamilia DESC), @BI,@nomecentrosaúde,@estado)
end

 exec  adicionarUtente 'a4598','Sara Fernandes','Rua avenida bombeiro','sarafernandes@gamil.com',984234623,'viva','F','2000-01-01','Centro de Saúde de Mirandela I','N';
 exec  adicionarUtente 'a0198','Carlos Fernandes','Rua senhor dos aflitos','carlosfernandes@gamil.com',903234623,'viva','M','2003-02-01','Centro de Saúde de Mirandela I','N';
 exec  adicionarUtente 'a1034','JoanaFernandes','Rua avenida bombeiro','joanafernandes@gamil.com',94554623,'viva','F','2010-01-02','Centro de Saúde de Mirandela I','N';
 exec  adicionarUtente 'a598','Manuela Fernandes','Rua avenida bombeiro','manuelafernandes@gamil.com',93334623,'viva','F','2020-01-01','Centro de Saúde de Mirandela I','N';
 exec  adicionarUtente 'a0598','Larisa Fernandes','Rua avenida bombeiro','larisafernandes@gamil.com',912234623,'viva','F','2000-03-02','Centro de Saúde de Mirandela II','N';
 exec  adicionarUtente 'a12598','Livia Fernandes','Rua avenida bombeiro','liviafernandes@gamil.com',9344434623,'viva','F','2000-01-11','Centro de Saúde de Mirandela I','N';
 exec  adicionarUtente 'a1394','Quinina Fernandes','Rua avenida bombeiro','quininafernandes@gamil.com',96634623,'viva','F','2000-01-21','Centro de Saúde de Mirandela II','N';
 exec  adicionarUtente 'a3424','Anny Fernandes','Rua avenida bombeiro','annyfernandes@gamil.com',98446423,'viva','F','1990-01-15','Centro de Saúde de Mirandela II','N';
 exec  adicionarUtente 'a4224','Stella Fernandes','Rua avenida bombeiro','stellafernandes@gamil.com',977234623,'viva','F','2000-01-01','Centro de Saúde de Mirandela I','N';
 exec  adicionarUtente 'a4256','Pedro Fernandes','Rua avenida bombeiro','pedrofernandes@gamil.com',984234635,'viva','M','1989-06-19','Centro de Saúde de Mirandela II','N';
 exec  adicionarUtente 'a3556','Tatiana Fernandes','Rua avenida bombeiro','tatinafernandes@gamil.com',984234578,'viva','F','2010-01-04','Centro de Saúde de Mirandela I','N';
 exec  adicionarUtente 'a31223','Daniela Fernandes','Rua avenida bombeiro','sarafernandes@gamil.com',984234668,'viva','F','2000-01-01','Centro de Saúde de Mirandela II','N';
 exec  adicionarUtente 'a09134','Tania Fernandes','Rua avenida bombeiro','taniafernandes@gamil.com',984234623,'viva','F','2000-01-01','Centro de Saúde de Mirandela I','N';
 exec  adicionarUtente 'a1234','Ney Manuel','Rua avenida bombeiro','neyfernandes@gamil.com',93554623,'viva','M','2000-01-01','Centro de Saúde de Mirandela I','N';
 exec  adicionarUtente 'a6552','Valentina Monteiro','Rua avenida bombeiro','vaniafernandes@gamil.com',934234623,'viva','F','2000-12-08','Centro de Saúde de Mirandela I','N';
 exec   adicionarUtente 'e2445','Ricardina Monteiro','Rua avenida bombeiro','dfffernandes@gamil.com',934234690,'viva','F','2020-09-01','Centro de Saúde de Mirandela I','N';
 exec   adicionarUtente '5092','Roberto Monteiro','Rua avenida bombeiro','vaniafernandes@gamil.com',934234691,'viva','M','2000-04-18','Centro de Saúde de Mirandela I','N';

 --procedure que adiciona o tipo de Consulta
create procedure AdicionarTipoConsulta(@descrição varchar(45))as
Insert into TipoConsulta values(@descrição);

exec AdicionarTipoConsulta 'Consulta Aberta';
exec AdicionarTipoConsulta 'Consulta de Apoio Domicilário';
exec AdicionarTipoConsulta 'Consulta de Diabetes';
exec AdicionarTipoConsulta 'Planeamento Familiar';
exec AdicionarTipoConsulta 'Consulta de Saúde infantil';
exec AdicionarTipoConsulta 'Consulta de Saúde Materna';
exec AdicionarTipoConsulta 'Consulta Programada e Vigilância de saúde';

--procedure para Adicionar Tipo de Exame
create procedure AdicionarTipoExame(@nome varchar(25)) as
insert into TipoExame values(@nome);
exec AdicionarTipoExame 'Hemograma';
exec AdicionarTipoExame  'Colesterol';
exec AdicionarTipoExame  'Ureia e Creatinina';
exec AdicionarTipoExame  'Papanicolau';
exec AdicionarTipoExame   'Exames de urina';
exec AdicionarTipoExame   'Exames de fezes';
exec AdicionarTipoExame  'Glicemia';
exec AdicionarTipoExame 'Transaminases (ALT e AST) ou TGP e TGO';

--procedure pra Agendar uma Consulta  
create procedure [AgendarConsulta](
@tipoconsulta varchar(45), @utente int,@data datetime) as
insert into Consulta values(@tipoconsulta,
(select  medicofamilia from Utente where numeroUtente =@utente),
@utente,@data);
exec AgendarConsulta 'Consulta de Saúde infantil',1, '2022-05-05';
exec AgendarConsulta 'Consulta Aberta',2, '2022-02-06';
exec AgendarConsulta 'Consulta de Saúde Materna',3, '2022-03-08';
exec AgendarConsulta 'Planeamento Familiar',4, '2022-04-07';
exec AgendarConsulta 'Consulta Programada e Vigilância de saúde',5, '2022-01-25';
exec AgendarConsulta 'Consulta de Saúde infantil',6, '2022-01-30';

--procedure que Cancela uma Consulta 
create procedure [CancelarConsulta](@codigoConsulta int) as
delete from Consulta Where codigoConsulta=@codigoConsulta;
exec CancelarConsulta 2;
--precedure que Agenda uma Vacina
create procedure [AgendarVacina](@utente int,@tipovacina varchar(20)) as
insert into Vacina  (utente,tipovacina) values(@utente,@tipovacina);
exec AgendarVacina 5,'covid19';

--procedure que Cancela um agendamento de vacina
create procedure [CancelarVacina](@numeroVacina int) as
delete from Vacina Where numeroVacina=@numeroVacina;
exec CancelarVacina 5;


--procedure  que   que vai consultar uma consulta de um utente
create procedure [ConsultarConsulta](@utente int) as
select* from Consulta where utente=@utente and data >= getdate() ;
exec ConsultarConsulta 4;


 
--Procedure para Listar os Utentes registados:
CREATE procedure ListarUtentes
AS
IF exists
(SELECT *from Utente )
BEGIN
PRINT 'Listar Utentes'
SELECT numeroUtente ,medicofamilia,BI,nomecentroSaúde FROM Utente;
END

exec ListarUtentes;
--Procedure para Listar os Funcionários registados:
CREATE procedure [Listar_Funcionarios]
AS
IF exists
(SELECT *from Funcionario )
BEGIN
PRINT 'Lista dos Funcionarios'
SELECT codigofun,cargo,BI,estado,salario
FROM Funcionario
END
exec Listar_Funcionarios;
--Procedure para Listar os Medicos registados:
CREATE procedure [Listar_Medicos]
AS
IF exists
(SELECT *from Medico )
BEGIN
PRINT 'Lista dos Medico'
SELECT numeroRegisto,codigofun,especialidade
FROM Medico
END
exec Listar_Medicos;
--Procedure para Listar os Enfermeiros registados:
CREATE procedure [Listar_Enfermeiro]
AS
IF exists
(SELECT *from Enfermeiro )
BEGIN
PRINT 'Lista dos Enfermeiro'
SELECT numeroRegisto,codigofun
FROM Enfermeiro
END
exec Listar_Enfermeiro;
--Procedure para Listar os Administrador registados:
CREATE procedure [Listar_Administrador]
AS
IF exists
(SELECT *from Admistrador )
BEGIN
PRINT 'Lista dos Administrador'
SELECT codigofun
FROM Admistrador
END
exec Listar_Administrador;
--Procedure para Listar as pessoas registados:
CREATE procedure [Listar_Pessoas]
AS
IF exists
(SELECT *from Pessoa )
BEGIN
PRINT 'Lista das Pessoas'
SELECT nome,morada,BI,Datanascimento,email,telefone,statusPessoa,sexo
FROM Pessoa
END
exec Listar_Pessoas;

--Procedure para Remover Utentes:
CREATE procedure [Remover_Utentes] @numeroUtente int AS
begin
delete
from Utente
where Utente.numeroUtente=@numeroUtente
END

exec Remover_Utentes 16

--procedure que adiciona Exames
create procedure [AdicionarExame](@nome varchar(25),@data datetime,@codigoConsulta int ,
@diagnostico varchar(50)) as
insert into Exame values(@nome,@data,@codigoConsulta,@diagnostico);
exec AdicionarExame 'Exames de fezes','2022-05-06',1,'ggggg';
 
--procedure que Atualiza diagnostico
create procedure[Atualizardiagnostico](@diagnostico varchar(50),@codigoExame  int) as
 UPDATE Exame
SET diagnostico=@diagnostico 
WHERE codigoExame=@codigoExame;
exec Atualizardiagnostico 'addaa',1;

--Procedure que mostra quantidade de consulta realizada por um determinado Medico
create procedure[QuantidadeConsultaRealizada](@codigoMedico int)as
select COUNT(*) as Total   from Consulta
where codigoMedico=@codigoMedico;
exec QuantidadeConsultaRealizada 1;

--procedure que mostra os funcionarios reformados
create procedure [MostarReformado] @codigofun int as
insert into Reformados
select codigofun, cargo, BI, salario from Funcionario where codigofun = @codigofun
Delete from Funcionario where codigofun = @codigofun;

--Listar o(s) Funcionario(s) que ganha(m) o maior salário
create procedure [listarFuncionarioMaiorSalatio]
SELECT count(*) 
FROM Funcionario
WHERE salario =
(SELECT max(salario)
FROM Funcionario)
exec listar_Funcionario_menor_salario;

--Verificar quantos funcionarios ganha(m) mais que o(s) Funcionario(s) de menor salário.
create procedure[listar_Funcionario_menor_salario] as
SELECT count(*) as QteFuncionarios
FROM Funcionario
WHERE salario >
(SELECT min(salario)
FROM Funcionario)


create procedure [Transferir](@numeroUtente int,@nomecentrosaúde varchar(45))as
insert into InsertedNumero(numero) values(@numeroUtente)
insert into TransferirUtente
select @numeroUtente, Pessoa.BI,nome,morada,email, telefone, nomecentroSaúde, sexo
 from Pessoa,Utente
where Pessoa.BI=Utente.BI and Utente.numeroUtente=@numeroUtente
exec MudaCentrSaude @numeroUtente, @nomecentrosaúde
exec TransferirHistorico @numeroUtente
delete from InsertedNumero;

--trigger para transferir historico vacina, consulta, exames, doença
create procedure TransferirHistorico @num int as
insert into HistoricoConsultas select codigoConsulta, tipoconsulta, nome, utente, data from Consulta, Medico, Funcionario, Pessoa
where Medico.codigofun = Funcionario.codigofun and Funcionario.BI = Pessoa.BI and Consulta.utente = @num
insert into HistoricoDoenca select numeroUtente, nome, descricao, tipo from Doenca where numeroUtente = @num
insert into HistoricoExame select utente, codigoExame, nome, Exame.data, Consulta.codigoConsulta, diagnostico  from Exame, Consulta, Utente
where Consulta.codigoConsulta = Exame.codigoConsulta and Consulta.utente = @num;


create procedure [MudaCentrSaude](@numeroUtente int, @nomecentrosaude varchar(45)) as
Update Utente
set nomecentroSaúde = @nomecentrosaude
where numeroUtente = @numeroUtente;


--sempre que ouver uma insercão na tabela Transferido o estado do Utente muda para para Transferido
create trigger [Mudarestado] 
on TransferirUtente after
insert  as
update  Utente
set estado ='T'
where numeroUtente =(select numero from InsertedNumero);

create table InsertedNumero(numero int not null)

--sempre que ouver uma insercão na tabela Reformado o Medico muda  para reformado
create trigger [MudarestadoReformado] 
on Reformado after
insert  as
update  Funcionario
set estado = 'R'
where codigofun = (select numero FROM InsertedNumero);



