create table Produto(
  cod_prod number(4),
  descricao_prod varchar(70),
  quantidade number(3),
  preco number(10,2)
);

set serveroutput on
set verify off

-------------------- Bloco 1 -------------------------

BEGIN
    DECLARE
        v_cod_prod Produto.cod_prod%TYPE;
        v_descricao_prod Produto.descricao_prod%TYPE;
        v_quantidade Produto.quantidade%TYPE;
        v_preco Produto.preco%TYPE;
    BEGIN
-- Captura os dados do produto a ser cadastrado
        v_cod_prod := &cod_prod;
        v_descricao_prod := '&descricao_prod';
        v_quantidade := &quantidade;
        v_preco := &preco;
        
-- Tenta inserir o produto na tabela
        BEGIN
            INSERT INTO Produto (cod_prod, descricao_prod, quantidade, preco)
            VALUES (v_cod_prod, v_descricao_prod, v_quantidade, v_preco);
            COMMIT;
            
            DBMS_OUTPUT.PUT_LINE('Produto cadastrado com sucesso.');
        EXCEPTION
-- Se já existir um produto com o mesmo código, informa o usuário
            WHEN dup_val_on_index THEN
                DBMS_OUTPUT.PUT_LINE('O produto já está cadastrado.');
        END;
    END;
END;

-------------------- Bloco 2 -------------------------

DECLARE
  v_cod_prod Produto.cod_prod%TYPE;
  v_descricao Produto.descricao_prod%TYPE;
  v_quantidade Produto.quantidade%TYPE;
  v_preco Produto.preco%TYPE;
  v_quantidade_compra Produto.quantidade%TYPE;
  v_valor_compra NUMBER;
BEGIN
  -- Recebe o código do produto a ser comprado
  v_cod_prod := &código_do_produto;
  
  -- Busca as informações do produto na tabela
  SELECT descricao_prod, quantidade, preco
  INTO v_descricao, v_quantidade, v_preco
  FROM Produto
  WHERE cod_prod = v_cod_prod;
  
  -- Se não encontrar nenhum registro, gera exceção
  IF SQL%NOTFOUND THEN
    RAISE_APPLICATION_ERROR(-20001, 'Produto não encontrado!');
  END IF;
  
  -- Recebe a quantidade a ser comprada
  v_quantidade_compra := &quantidade_compra;
  
  -- Verifica se a quantidade desejada está disponível em estoque
  IF v_quantidade_compra > v_quantidade THEN
    RAISE_APPLICATION_ERROR(-20002, 'Quantidade indisponível em estoque!');
  END IF;
  
  -- Calcula o valor da compra
  v_valor_compra := v_quantidade_compra * v_preco;
  
  -- Atualiza o estoque do produto
  UPDATE Produto
  SET quantidade = quantidade - v_quantidade_compra
  WHERE cod_prod = v_cod_prod;
  
  DBMS_OUTPUT.PUT_LINE('Compra realizada com sucesso!');
  DBMS_OUTPUT.PUT_LINE('Produto: ' || v_descricao);
  DBMS_OUTPUT.PUT_LINE('Quantidade comprada: ' || v_quantidade_compra);
  DBMS_OUTPUT.PUT_LINE('Valor total: ' || v_valor_compra);
EXCEPTION
  WHEN NO_DATA_FOUND THEN
    RAISE_APPLICATION_ERROR(-20003, 'Produto não encontrado!');
  WHEN OTHERS THEN
    RAISE_APPLICATION_ERROR(-20004, SQLERRM);
END;