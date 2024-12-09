-- Pacote PKG_ALUNO
CREATE OR REPLACE PACKAGE PKG_ALUNO IS
    -- Excluir aluno por ID e matrículas associadas
    PROCEDURE remover_aluno(p_id_aluno IN NUMBER);

    -- Cursor para alunos acima de 18 anos
    CURSOR listar_alunos_maiores_18 IS
        SELECT nome, data_nascimento
        FROM alunos
        WHERE EXTRACT(YEAR FROM SYSDATE) - EXTRACT(YEAR FROM data_nascimento) > 18;

    -- Cursor parametrizado para alunos de um curso
    CURSOR listar_alunos_por_curso(p_id_curso IN NUMBER) IS
        SELECT a.nome
        FROM alunos a
        JOIN matriculas m ON a.id_aluno = m.id_aluno
        WHERE m.id_curso = p_id_curso;
END PKG_ALUNO;
/ 

CREATE OR REPLACE PACKAGE BODY PKG_ALUNO IS
    -- Implementação da procedure para excluir aluno
    PROCEDURE remover_aluno(p_id_aluno IN NUMBER) IS
    BEGIN
        DELETE FROM matriculas WHERE id_aluno = p_id_aluno;
        DELETE FROM alunos WHERE id_aluno = p_id_aluno;
        COMMIT;
    END remover_aluno;
END PKG_ALUNO;
/ 

-- Pacote PKG_DISCIPLINA
CREATE OR REPLACE PACKAGE PKG_DISCIPLINA IS
    -- Adicionar nova disciplina
    PROCEDURE adicionar_disciplina(
        p_nome IN VARCHAR2,
        p_descricao IN VARCHAR2,
        p_carga_horaria IN NUMBER
    );

    -- Cursor para contar alunos por disciplina com mais de 10 alunos
    CURSOR contar_alunos_em_disciplinas IS
        SELECT d.nome AS disciplina, COUNT(m.id_aluno) AS total
        FROM disciplinas d
        LEFT JOIN matriculas m ON d.id_disciplina = m.id_disciplina
        GROUP BY d.nome
        HAVING COUNT(m.id_aluno) > 10;

    -- Cursor para média de idade em disciplina específica
    CURSOR calcular_media_idade(p_id_disciplina IN NUMBER) IS
        SELECT ROUND(AVG(EXTRACT(YEAR FROM SYSDATE) - EXTRACT(YEAR FROM a.data_nascimento)), 1) AS media_idade
        FROM alunos a
        JOIN matriculas m ON a.id_aluno = m.id_aluno
        WHERE m.id_disciplina = p_id_disciplina;

    -- Listar alunos matriculados em uma disciplina
    PROCEDURE exibir_alunos_em_disciplina(p_id_disciplina IN NUMBER);
END PKG_DISCIPLINA;
/ 

CREATE OR REPLACE PACKAGE BODY PKG_DISCIPLINA IS
    -- Implementação da procedure para adicionar disciplina
    PROCEDURE adicionar_disciplina(
        p_nome IN VARCHAR2,
        p_descricao IN VARCHAR2,
        p_carga_horaria IN NUMBER
    ) IS
    BEGIN
        INSERT INTO disciplinas (nome, descricao, carga_horaria)
        VALUES (p_nome, p_descricao, p_carga_horaria);
        COMMIT;
    END adicionar_disciplina;

    -- Implementação da procedure para exibir alunos de uma disciplina
    PROCEDURE exibir_alunos_em_disciplina(p_id_disciplina IN NUMBER) IS
    BEGIN
        FOR aluno IN (
            SELECT a.nome
            FROM alunos a
            JOIN matriculas m ON a.id_aluno = m.id_aluno
            WHERE m.id_disciplina = p_id_disciplina
        ) LOOP
            DBMS_OUTPUT.PUT_LINE('Aluno: ' || aluno.nome);
        END LOOP;
    END exibir_alunos_em_disciplina;
END PKG_DISCIPLINA;
/ 

-- Pacote PKG_PROFESSOR
CREATE OR REPLACE PACKAGE PKG_PROFESSOR IS
    -- Cursor para contar turmas por professor
    CURSOR listar_turmas_por_professor IS
        SELECT p.nome AS professor, COUNT(t.id_turma) AS total_turmas
        FROM professores p
        LEFT JOIN turmas t ON p.id_professor = t.id_professor
        GROUP BY p.nome
        HAVING COUNT(t.id_turma) > 1;

    -- Função que retorna número de turmas de um professor
    FUNCTION obter_total_turmas(p_id_professor IN NUMBER) RETURN NUMBER;

    -- Função que retorna nome do professor de uma disciplina
    FUNCTION obter_professor_da_disciplina(p_id_disciplina IN NUMBER) RETURN VARCHAR2;
END PKG_PROFESSOR;
/ 

CREATE OR REPLACE PACKAGE BODY PKG_PROFESSOR IS
    -- Implementação da função para obter total de turmas de um professor
    FUNCTION obter_total_turmas(p_id_professor IN NUMBER) RETURN NUMBER IS
        v_total_turmas NUMBER := 0;
    BEGIN
        SELECT COUNT(*)
        INTO v_total_turmas
        FROM turmas
        WHERE id_professor = p_id_professor;

        RETURN v_total_turmas;
    END obter_total_turmas;

    -- Implementação da função para obter o professor responsável por uma disciplina
    FUNCTION obter_professor_da_disciplina(p_id_disciplina IN NUMBER) RETURN VARCHAR2 IS
        v_professor_nome VARCHAR2(100);
    BEGIN
        SELECT p.nome
        INTO v_professor_nome
        FROM professores p
        JOIN disciplinas d ON d.id_professor = p.id_professor
        WHERE d.id_disciplina = p_id_disciplina;

        RETURN v_professor_nome;
    EXCEPTION
        WHEN NO_DATA_FOUND THEN
            RETURN 'Nenhum professor encontrado';
    END obter_professor_da_disciplina;
END PKG_PROFESSOR;
/
