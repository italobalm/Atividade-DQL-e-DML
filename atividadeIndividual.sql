-- Relatorio 1 BD: LLista dos empregados admitidos entre 2019-01-01 e 2022-03-31, trazendo as colunas 
-- (Nome Empregado, CPF Empregado, Data Admissão,  Salário, Departamento, Número de Telefone), ordenado por data de admissão decrescente;

SELECT 
    e.nome AS nomeEmpregado,
    e.cpf AS cpfEmpregado,
    e.dataAdm AS dataAdmissao,
    e.salario AS salario,
    d.nome AS nomeDepartamento,
    t.numero AS telefone
FROM 
    Empregado e
INNER JOIN 
    Departamento d ON e.Departamento_idDepartamento = d.idDepartamento

JOIN 
telefone t ON t.Empregado_cpf

WHERE 
    e.dataAdm BETWEEN '2019-01-01' AND '2022-03-31'
ORDER BY 
    e.dataAdm DESC;

-- Relatório 2:  Lista dos empregados que ganham menos que a média salarial dos funcionários do Petshop, trazendo as colunas (Nome Empregado, CPF Empregado, Data Admissão,  
-- Salário, Departamento, Número de Telefone), ordenado por nome do empregado;

SELECT 
    e.nome AS nomeEmpregado,
    e.cpf AS cpfEmpregado,
    e.dataAdm AS dataAdmissao,
    e.salario AS salario,
    d.nome AS nomeDepartamento,
    e.email AS numeroTelefone
FROM 
    Empregado e
INNER JOIN 
    Departamento d ON e.Departamento_idDepartamento = d.idDepartamento
WHERE 
    e.salario < (SELECT AVG(salario) FROM Empregado)
ORDER BY 
    e.nome;
    
-- Relatório 3: Lista dos departamentos com a quantidade de empregados total por cada departamento, trazendo também a média salarial dos funcionários do departamento 
-- e a média de comissão recebida pelos empregados do departamento, com as colunas (Departamento, Quantidade de Empregados, Média Salarial, Média da Comissão), ordenado por nome do departamento;

SELECT 
    d.nome AS nomeDepartamento,
    COUNT(e.cpf) AS quantidadeEmpregados,
    AVG(e.salario) AS mediaSalarial,
    AVG(e.comissao) AS mediaComissao
FROM 
    Departamento d
LEFT JOIN 
    Empregado e ON e.Departamento_idDepartamento = d.idDepartamento
GROUP BY 
    d.nome
ORDER BY 
    d.nome;

-- Relatório 4:  Lista dos empregados com a quantidade total de vendas já realiza por cada Empregado, além da soma do valor total das vendas do empregado e a soma de suas comissões, 
-- trazendo as colunas (Nome Empregado, CPF Empregado, Sexo, Salário, Quantidade Vendas, Total Valor Vendido, Total Comissão das Vendas), ordenado por quantidade total de vendas realizadas;

SELECT 
    e.nome AS nomeEmpregado,
    e.cpf AS cpfEmpregado,
    e.sexo AS sexo,
    e.salario AS salario,
    COUNT(v.idVenda) AS quantidadeVendas,
    SUM(v.valor) AS valorTotal,
    SUM(v.comissao) AS comissaoTotal
FROM 
    Empregado e
LEFT JOIN 
    Venda v ON e.cpf = v.Empregado_cpf
GROUP BY 
    e.cpf
ORDER BY 
    quantidadeVendas DESC;

-- Relatório 5:  Lista dos empregados que prestaram Serviço na venda computando a quantidade total de vendas realizadas com serviço por cada Empregado, além da soma do valor total 
-- apurado pelos serviços prestados nas vendas por empregado e a soma de suas comissões, trazendo as colunas (Nome Empregado, CPF Empregado, Sexo, Salário, 
-- Quantidade Vendas com Serviço, Total Valor Vendido com Serviço, Total Comissão das Vendas com Serviço), ordenado por quantidade total de vendas realizadas;

SELECT 
    e.nome AS nomeEmpregado,
    e.cpf AS cpfEmpregado,
    e.sexo AS sexo,
    e.salario AS salario,
    COUNT(DISTINCT isv.Venda_idVenda) AS qntdVendasServico,
    SUM(isv.valor) AS qntdVendasServico,
    SUM(isv.desconto) AS qntdVendasServico
FROM 
    Empregado e
LEFT JOIN 
    itensServico isv ON e.cpf = isv.Empregado_cpf
GROUP BY 
    e.cpf
ORDER BY 
    qntdVendasServico DESC;
    
-- Relatório 6: Lista dos serviços já realizados por um Pet, trazendo as colunas (Nome do Pet, Data do Serviço, Nome do Serviço, Quantidade, Valor, Empregado que realizou o Serviço), 
-- ordenado por data do serviço da mais recente a mais antiga;

SELECT 
    p.nome AS nomePet,
    isv.valor AS valorServico,
    isv.desconto AS desconto,
    s.nome AS nomeServico,
    isv.quantidade AS quantidade,
    e.nome AS empregadoResponsavel
FROM 
    PET p
INNER JOIN 
    itensServico isv ON p.idPET = isv.PET_idPET
INNER JOIN 
    Servico s ON isv.Servico_idServico = s.idServico
INNER JOIN 
    Empregado e ON isv.Empregado_cpf = e.cpf
ORDER BY 
    isv.valor DESC;
    
-- Relatório 7: Lista das vendas já realizados para um Cliente, trazendo as colunas (Data da Venda, Valor, Desconto, Valor Final, Empregado que realizou a venda), ordenado
-- por data do serviço da mais recente a mais antiga;

SELECT 
    v.data AS dataVenda,
    v.valor AS valor,
    v.desconto AS desconto,
    (v.valor - v.desconto) AS valorTotal,
    e.nome AS empregadoResponsavel
FROM 
    Venda v
INNER JOIN 
    Empregado e ON v.Empregado_cpf = e.cpf
WHERE 
    v.Cliente_cpf = '017.503.885-61'
ORDER BY 
    v.data DESC;


-- Relatório 8: Lista dos 10 serviços mais vendidos, trazendo a quantidade vendas cada serviço, o somatório total dos valores de serviço vendido, trazendo as colunas (Nome do Serviço, 
-- Quantidade Vendas, Total Valor Vendido), ordenado por quantidade total de vendas realizadas;

SELECT 
    s.nome AS nomeServico,
    COUNT(isv.Servico_idServico) AS qntdVendas,
    SUM(isv.valor) AS valorTotal
FROM 
    Servico s
INNER JOIN 
    itensServico isv ON s.idServico = isv.Servico_idServico
GROUP BY 
    s.nome
ORDER BY 
    qntdVendas DESC
LIMIT 10;

-- Relatório 9: Lista das formas de pagamentos mais utilizadas nas Vendas, informando quantas vendas cada forma de pagamento já foi 
-- relacionada, trazendo as colunas (Tipo Forma Pagamento, Quantidade Vendas, Total Valor Vendido), ordenado por quantidade total de vendas realizadas;

SELECT 
    fp.tipo AS formaPagamento,
    COUNT(fp.idFormaPgVenda) AS qntdVendas,
    SUM(v.valor) AS valorTotal
FROM 
    FormaPgVenda fp
INNER JOIN 
    Venda v ON fp.idFormaPgVenda = v.idVenda 
GROUP BY 
    fp.tipo
ORDER BY 
    qntdVendas DESC;

-- Relatório 10: Balaço das Vendas, informando a soma dos valores vendidos por dia, trazendo as colunas (Data Venda, Quantidade de Vendas, Valor Total Venda), 
-- ordenado por Data Venda da mais recente a mais antiga;
SELECT 
    v.data AS dataVenda,
    COUNT(v.idVenda) AS qntdVendas,
    SUM(v.valor) AS valorTotal
FROM 
    Venda v
GROUP BY 
    v.data
ORDER BY 
    v.data DESC;
    
-- Relatório 11:  Lista dos Produtos, informando qual Fornecedor de cada produto, trazendo as colunas (Nome Produto, Valor Produto, Categoria do Produto, Nome Fornecedor, 
-- Email Fornecedor, Telefone Fornecedor), ordenado por Nome Produto;

SELECT 
    p.nome AS nomeProduto,
    p.valorVenda AS valorProduto,
    ic.quantidade AS qntdProduto,
    f.nome AS nomeFornecedor,
    f.email AS emailFornecedor
FROM
    Produtos p
INNER JOIN 
    ItensCompra ic ON p.idProduto = ic.Produtos_idProduto
INNER JOIN 
    Compras c ON ic.Compras_idCompra = c.idCompra
INNER JOIN 
    Fornecedor f ON c.Fornecedor_cpf_cnpj = f.cpf_cnpj
ORDER BY 
    p.nome;

    
-- Relatório 12: Lista dos Produtos mais vendidos, informando a quantidade (total) de vezes que cada produto
-- participou em vendas e o total de valor apurado com a venda do produto, trazendo as colunas (Nome Produto, Quantidade (Total) Vendas, Valor Total Recebido pela Venda do Produto), 
-- ordenado por quantidade de vezes que o produto participou em vendas;

SELECT 
    p.nome AS nomeProduto,
    COUNT(ic.Produtos_idProduto) AS qntdVendas,
    SUM(ic.valorCompra) AS valorTotal
FROM 
    Produtos p
INNER JOIN 
    ItensCompra ic ON p.idProduto = ic.Produtos_idProduto
GROUP BY 
    p.nome
ORDER BY 
    qntdVendas DESC;