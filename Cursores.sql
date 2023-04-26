create table funcionario (
    cd_fun number(2) primary key,
    nm_fun varchar2(20),
    salario number(10,2),
    dt_adm date
);

--drop table funcionario

insert all
    into funcionario values(1, 'Marcel', 10000, to_date('17/04/2000', 'dd/mm/yyyy'))
    into funcionario values(2, 'Claudia', 16000, to_date('02/10/1998', 'dd/mm/yyyy'))
    into funcionario values(3, 'Joaquim', 5500, to_date('10/07/2010', 'dd/mm/yyyy'))
    into funcionario values(4, 'valéria', 7300, to_date('08/06/2015', 'dd/mm/yyyy'))
select * from dual;

set serveroutput on
set verify off
 
declare
    cursor c_exibe is select nm_fun, salario from funcionario;
    v_exibe c_exibe%rowtype;
begin
    open c_exibe;
    loop
      fetch c_exibe into v_exibe;
    exit when c_exibe%notfound;
    dbms_output.put_line('Nome:'||v_exibe.nm_fun||'-Salário:'||v_exibe.salario);
    end loop;
    close c_exibe;
end;

-- usando o for
declare
    cursor c_exibe is select nm_fun, salario from fruncionario;
begin
    for v_exibe in c_exibe loop
      dbms_output.put_line('Nome:'||v_exibe.nm_fun||'-Salário:'||v_exibe.salario);
    end loop;
end;

-------- EXERCICIO 1 ----------

alter table funcionario add tempo_fun number(5);

declare
    cursor c_exibe is select * from funcionario;
begin
    for v_exibe in c_exibe loop
      if(v_exibe.tempo_fun/30) >= 150 then
       update funcionario set salario = salario * 1.1 where cd_fun = v_exibe.cd_fun;
      else
       update funcionario set salario = salario * 1.05 where cd_fun = v_exibe.cd_fun;
      end if;
    end loop;
end;
------------------------------------- sysdate

DECLARE
  CURSOR C_exibe IS SELECT * FROM funcionario;
BEGIN
  FOR V_exibe IN C_exibe LOOP
    update funcionario set tempo = sysdate - v_exibe.dt_adm
    where cd_fun = v_exibe.cd_fun;
  END LOOP;
END;

--------------------------------------------

declare
  cursor c_exibe is select * from funcionario;
  v_exibe c_exibe%rowtype;
begin
  open c_exibe;
  loop
   fetch c_exibe into v_exibe;
  exit when c_exibe%notfound;
  update funcionario set tempo = sysdate - v_exibe.dt_adm
  where cd_fun = v_exibe.cd_fun;
  end loop;
  close c_exibe;
end;