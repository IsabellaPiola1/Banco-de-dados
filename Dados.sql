set serveroutput on
drop table t_prod1;
drop table t_prod2;
drop table t_prod3;


create table t_prod1 (nm_prod varchar(3));
create table t_prod2 (nm_prod varchar(3));
create table t_prod3 (nm_prod varchar(3));


insert all
    into t_prod1 values('A')
    into t_prod1 values('B')
    into t_prod1 values('D')
    into t_prod1 values('F')
    into t_prod1 values('G')
select * from dual;

insert all
    into t_prod2 values('A')
    into t_prod2 values('C')
    into t_prod2 values('D')
    into t_prod2 values('E')
    into t_prod2 values('I')
    into t_prod2 values('J')
select * from dual;
commit;

 

delete from t_prod3;
select * from t_prod3;

 

declare
-- cursor 1, responsavel pela transferencia de dados da table 1 para a 3
    cursor c_prod1 is select * from t_prod1;
-- cursor 2, responsavel pela transferencia de dados diferentes da tabela 2
-- com a tabela 1 para a 3
    cursor c_prod2 is select * from t_prod2 
    where t_prod2.nm_prod not in (Select nm_prod from t_prod1);
-- cursor 3, responsavel pela exibição dos dados da tabela 3    
    cursor c_lista is select * from t_prod3;
begin
-- processamento cursor 1
    for v_prod1 in c_prod1 loop
-- inserindo dados em t_prod3
        insert into t_prod3 values(v_prod1.nm_prod);
    end loop;
-- processamento cursor 2
    for v_prod2 in c_prod2 loop
-- inserindo dados em t_prod3 (apenas os ainda não cadastrados em t_prod3)
        insert into t_prod3 values(v_prod2.nm_prod);
    end loop;
-- validando os dados
    commit;
-- processamento cursor 3
    for v_prod3 in c_lista loop
-- saída de dados, exibindo conteúdo da t_prod3
        dbms_output.put_line(v_prod3.nm_prod);
    end loop;
end;
