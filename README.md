# Scripts de Pacotes SQL - Oracle

Este repositório contém scripts desenvolvidos para criar pacotes PL/SQL no Oracle, implementando operações específicas para gerenciamento de alunos, disciplinas, professores e suas interações no contexto acadêmico.

---

## Pacotes Criados

### **1. PKG_ALUNO**
- **Procedure `remover_aluno`**: Exclui um aluno e todas as matrículas associadas, com base no ID fornecido.
- **Cursor `listar_alunos_maiores_18`**: Retorna uma lista de alunos maiores de 18 anos, exibindo nome e data de nascimento.
- **Cursor `listar_alunos_por_curso`**: Recebe o ID de um curso e retorna os nomes dos alunos matriculados nesse curso.

### **2. PKG_DISCIPLINA**
- **Procedure `adicionar_disciplina`**: Insere uma nova disciplina na base de dados, com nome, descrição e carga horária fornecidos como parâmetros.
- **Cursor `contar_alunos_em_disciplinas`**: Lista disciplinas com mais de 10 alunos matriculados, exibindo o nome e a quantidade total de alunos.
- **Cursor `calcular_media_idade`**: Calcula e retorna a média de idade dos alunos matriculados em uma disciplina especificada.
- **Procedure `exibir_alunos_em_disciplina`**: Mostra os nomes dos alunos matriculados em uma disciplina específica, com base no ID fornecido.

### **3. PKG_PROFESSOR**
- **Cursor `listar_turmas_por_professor`**: Retorna os nomes dos professores e o número total de turmas que cada um leciona, incluindo apenas aqueles com mais de uma turma.
- **Function `obter_total_turmas`**: Aceita o ID de um professor e retorna o número total de turmas que ele leciona.
- **Function `obter_professor_da_disciplina`**: Recebe o ID de uma disciplina e retorna o nome do professor responsável.

---

## Requisitos para Execução

### 1. **Estrutura do Banco de Dados**
- Certifique-se de que as tabelas necessárias foram criadas e possuem os seguintes relacionamentos:
  - **Tabelas Obrigatórias**:
    - `alunos`, `disciplinas`, `matriculas`, `cursos`, `professores`, `turmas`.
  - **Relacionamentos**:
    - `matriculas.id_aluno` → `alunos.id_aluno`.
    - `matriculas.id_disciplina` → `disciplinas.id_disciplina`.
    - `disciplinas.id_professor` → `professores.id_professor`.
    - `turmas.id_professor` → `professores.id_professor`.

### 2. **Execução dos Scripts**
- Utilize ferramentas como SQL*Plus, SQL Developer ou outra de sua escolha para executar os scripts.
- Scripts a serem executados:
  - `pkg_aluno.sql`
  - `pkg_disciplina.sql`
  - `pkg_professor.sql`

### 3. **Ativação dos Pacotes**
- Após a execução, os pacotes estarão disponíveis para uso no banco de dados e poderão ser chamados em blocos PL/SQL.

---

## Exemplos de Uso

### **1. Exemplo: Cursor `listar_alunos_maiores_18` (PKG_ALUNO)**
Este cursor lista todos os alunos maiores de 18 anos.
```sql
BEGIN
    FOR aluno IN PKG_ALUNO.listar_alunos_maiores_18 LOOP
        DBMS_OUTPUT.PUT_LINE('Nome: ' || aluno.nome || ', Data de Nascimento: ' || aluno.data_nascimento);
    END LOOP;
END;
/
```

### **2. Exemplo: Procedure `exibir_alunos_em_disciplina` (PKG_DISCIPLINA)**
Este procedimento exibe os nomes dos alunos matriculados em uma disciplina específica.
```sql
BEGIN
    PKG_DISCIPLINA.exibir_alunos_em_disciplina(201);
END;
/
```

### **3. Exemplo: Function `obter_total_turmas` (PKG_PROFESSOR)**
Esta função retorna o total de turmas atribuídas a um professor.
```sql
DECLARE
    v_total_turmas NUMBER;
BEGIN
    v_total_turmas := PKG_PROFESSOR.obter_total_turmas(102);
    DBMS_OUTPUT.PUT_LINE('Total de Turmas: ' || v_total_turmas);
END;
/
```

### **4. Exemplo: Cursor `listar_turmas_por_professor` (PKG_PROFESSOR)**
Este cursor lista professores com mais de uma turma e o número total de turmas.
```sql
BEGIN
    FOR professor IN PKG_PROFESSOR.listar_turmas_por_professor LOOP
        DBMS_OUTPUT.PUT_LINE('Professor: ' || professor.professor || ', Total de Turmas: ' || professor.total_turmas);
    END LOOP;
END;
/
```

---

## Estrutura do Repositório
- **`pkg_aluno.sql`**: Script para criação do pacote e corpo do pacote `PKG_ALUNO`.
- **`pkg_disciplina.sql`**: Script para criação do pacote e corpo do pacote `PKG_DISCIPLINA`.
- **`pkg_professor.sql`**: Script para criação do pacote e corpo do pacote `PKG_PROFESSOR`.
- **`README.md`**: Documentação com instruções de uso e exemplos.

---

## Considerações Finais
- O código foi desenvolvido para consolidar conhecimentos em PL/SQL, incluindo procedures, functions e cursores.
- Garantimos a utilização de boas práticas de programação e testes no ambiente Oracle.
- Contribuições e melhorias são bem-vindas!
