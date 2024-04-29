create database TarefaLabBDAula_Cursores
go
use TarefaLabBDAula_Cursores
go
-- Tabela Curso
create table Curso (
    codigoCurso	int,
    nome	varchar(100),
    duracao int
	Primary key(codigoCurso)
)
go
-- Tabela Disciplinas
create table Disciplinas (
    codigoDisciplina varchar(10),
    nome varchar(100),
    carga_horaria int
	Primary key(codigoDisciplina)
)
go
-- Tabela Disciplina_Curso
create table Disciplina_Curso (
    codigoDisciplina varchar(10),
    codigoCurso int
    foreign key (codigoDisciplina) references Disciplinas(codigoDisciplina),
    foreign key (codigoCurso) references Curso(codigoCurso),
    Primary key (codigoDisciplina, codigoCurso)
)
go
-- Inserir dados na tabela Curso
insert into Curso (codigoCurso, nome, duracao) values
(48, 'Análise e Desenvolvimento de Sistemas', 2880),
(51, 'Logística', 2880),
(67, 'Polímeros', 2880),
(73, 'Comércio Exterior', 2600),
(94, 'Gestão Empresarial', 2600)
go
-- Inserir dados na tabela Disciplinas
insert into Disciplinas (codigoDisciplina, nome, carga_horaria) values
('ALG001', 'Algoritmos', 80),
('ADM001', 'Administração', 80),
('LHW010', 'Laboratório de Hardware', 40),
('LPO001', 'Pesquisa Operacional', 80),
('FIS003', 'Física I', 80),
('FIS007', 'Físico Química', 80),
('CMX001', 'Comércio Exterior', 80),
('MKT002', 'Fundamentos de Marketing', 80),
('INF001', 'Informática', 40),
('ASI001', 'Sistemas de Informação', 80);
go
-- Inserir dados na tabela Disciplina_Curso
INSERT INTO Disciplina_Curso (codigoDisciplina, codigoCurso) VALUES
('ALG001', 48),
('ADM001', 48),
('ADM001', 51),
('ADM001', 73),
('ADM001', 94),
('LHW010', 48),
('LPO001', 51),
('FIS003', 67),
('FIS007', 67),
('CMX001', 51),
('CMX001', 73),
('MKT002', 51),
('MKT002', 94),
('INF001', 51),
('INF001', 73),
('ASI001', 48),
('ASI001', 94);
go

create function fn_infoCurso(@codigoCurso int)
returns @tabela table (
	codigoDisciplina varchar(10),
    nomeDisciplina varchar(100),
    cargaHorariaDisciplina int,
    nomeCurso varchar(100)
)
as 
begin

	declare @codigoDisciplina varchar(10),
			@nomeDisciplina varchar(100),
			@cargaHorariaDisciplina int,
			@nomeCurso varchar(100)

	declare c cursor for
			select dc.CodigoDisciplina, d.nome, d.carga_horaria, c.nome
			from Disciplina_Curso dc, Disciplinas d, Curso c
			where dc.codigoDisciplina = d.codigoDisciplina and
				  dc.codigoCurso = c.codigoCurso and
				  c.codigoCurso = @codigoCurso


	open c

	fetch next from c into @codigoDisciplina, @nomeDisciplina, @cargaHorariaDisciplina, @nomeCurso


	while @@FETCH_STATUS = 0
	begin
		insert into @tabela (codigoDisciplina, nomeDisciplina, cargaHorariaDisciplina, nomeCurso)
        values (@codigoDisciplina, @nomeDisciplina, @cargaHorariaDisciplina, @nomeCurso)

        fetch next from c into @codigoDisciplina, @nomeDisciplina, @cargaHorariaDisciplina, @nomeCurso
    end

	close c
	deallocate c
	return

end


select * from dbo.fn_infoCurso(48)