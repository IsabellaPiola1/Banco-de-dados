drop table aluno cascade constraints;
create table aluno (ra number(1) primary key, nome varchar(20));

insert into aluno values (1, 'Marcel');
insert into aluno values (2, 'Marcel');
insert into aluno values (3, 'Marcel');
commit;

begin
  insert into aluno values (1, 'Marcel');
  exception
    when dup_val_on_index then
      dbms_output.put_line('Ra já cadastrado');
end;

select * from aluno;
declare 
  v_ra aluno.ra%type := &ra;
  v_nome aluno.nome%type;
begin
  select nome into v_nome from aluno where ra = v_ra;
  dbms_output.put_line(v_ra ||' - '||v_nome);
  exception
    --when no_data_found then 
    --dbms_output.put_line('não há nenhum aluno com este ra');
  when too_many_rows then
    dbms_output.put_line('há mais de um aluno com este ra');
end;

drop table produto_cp;

CREATE TABLE PRODUTO_Cp (
CODIGO NUMBER(4),
CATEGORIA CHAR(1),
VALOR NUMBER(4,2));

INSERT INTO PRODUTO_Cp VALUES (1001,'A',7.55);
INSERT INTO PRODUTO_Cp VALUES (1002,'B',5.95);
INSERT INTO PRODUTO_Cp VALUES (1003,'C',3.45);  
commit;

select * from produto_cp;

declare
    cursor c_bonus is select * from produto_cp;
begin
    for v_bonus in c_bonus loop
-- verificando se a categoria é A
        if v_bonus.categoria = 'A' then
-- calculando o aumento
            v_bonus.valor := v_bonus.valor * 1.05;
-- atualizando a tabela
            update produto_cp set valor = v_bonus.valor 
            where codigo = v_bonus.codigo;
        elsif v_bonus.categoria = 'B' then
            v_bonus.valor := v_bonus.valor * 1.10;
            update produto_cp set valor = v_bonus.valor 
            where codigo = v_bonus.codigo;
        else
            v_bonus.valor := v_bonus.valor * 1.15;
            update produto_cp set valor = v_bonus.valor 
            where codigo = v_bonus.codigo;
        end if;
        dbms_output.put_line(v_bonus.categoria||' - '||v_bonus.valor);
    end loop;
    commit;
end;
  
select * from produto_cp; 

------------------------------------------------------------------------

set serveroutput on

drop table aluno cascade constraints;
create table aluno (ra number(1) primary key, nome varchar(20));

insert into aluno values (1,'Marcel');
insert into aluno values (2,'Adriana');
insert into aluno values (3,'Samuel');
commit;

begin
    insert into aluno values (1,'Marcel');
    exception
        when dup_val_on_index then
            dbms_output.put_line('Ra já cadastrado');
end;

select * from aluno;
DECLARE
    V_RA ALUNO.RA%TYPE := &ra;
    V_NOME ALUNO.NOME%TYPE;
BEGIN
    SELECT NOME INTO V_NOME FROM ALUNO WHERE RA = V_RA;
    DBMS_OUTPUT.PUT_LINE(V_RA ||' - '|| V_NOME);
    EXCEPTION
        WHEN NO_DATA_FOUND THEN
            DBMS_OUTPUT.PUT_LINE ('Não há nenhum aluno com este RA');
        WHEN TOO_MANY_ROWS THEN
            DBMS_OUTPUT.PUT_LINE ('Retorna mais de um aluno');
END;

select * from aluno;
DECLARE
    V_CONTA NUMBER(2);
    TURMA_CHEIA EXCEPTION;
BEGIN
    SELECT COUNT(RA) INTO V_CONTA FROM ALUNO;
    IF V_CONTA = 5 THEN 
        RAISE TURMA_CHEIA;
    ELSE 
        INSERT INTO ALUNO VALUES (&ra,'&nome');
    END IF;
    EXCEPTION
    WHEN TURMA_CHEIA THEN
        DBMS_OUTPUT.PUT_LINE('Não foi possível incluir: turma cheia');
END;