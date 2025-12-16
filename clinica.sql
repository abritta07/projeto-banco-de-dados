SET FOREIGN_KEY_CHECKS = 0;

DROP SCHEMA IF EXISTS `clinica_db`;
CREATE SCHEMA IF NOT EXISTS `clinica_db` DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci;
USE `clinica_db`;

CREATE TABLE `Pessoa` (
    `idPessoa` INT NOT NULL AUTO_INCREMENT,
    `nome` VARCHAR(100) NOT NULL,
    `cpf` VARCHAR(14) NOT NULL,
    `data_nascimento` DATE NULL,
    `telefone` VARCHAR(20) NULL,
    `endereco` VARCHAR(255) NULL,
    `tipo` VARCHAR(20) NOT NULL,
    `created_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    `updated_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    `deleted_at` TIMESTAMP NULL,
    PRIMARY KEY (`idPessoa`)
) ENGINE = InnoDB DEFAULT CHARSET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci;

CREATE TABLE `Paciente` (
    `Pessoa_idPessoa` INT NOT NULL,
    `historico_medico` LONGTEXT NULL,
    `data_cadastro` DATE NOT NULL,
    `created_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    `updated_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    `deleted_at` TIMESTAMP NULL,
    PRIMARY KEY (`Pessoa_idPessoa`),
    CONSTRAINT `fk_Paciente_Pessoa` FOREIGN KEY (`Pessoa_idPessoa`)
        REFERENCES `Pessoa` (`idPessoa`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE = InnoDB DEFAULT CHARSET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci;

CREATE TABLE `Medico` (
    `Pessoa_idPessoa` INT NOT NULL,
    `crm` VARCHAR(15) NOT NULL,
    `especialidade` VARCHAR(100) NULL,
    `created_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    `updated_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    `deleted_at` TIMESTAMP NULL,
    PRIMARY KEY (`Pessoa_idPessoa`),
    CONSTRAINT `fk_Medico_Pessoa` FOREIGN KEY (`Pessoa_idPessoa`)
        REFERENCES `Pessoa` (`idPessoa`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE = InnoDB DEFAULT CHARSET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci;

CREATE TABLE `Funcionario` (
    `Pessoa_idPessoa` INT NOT NULL,
    `cargo` VARCHAR(50) NOT NULL,
    `data_contratacao` DATE NOT NULL,
    `created_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    `updated_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    `deleted_at` TIMESTAMP NULL,
    PRIMARY KEY (`Pessoa_idPessoa`),
    CONSTRAINT `fk_Funcionario_Pessoa` FOREIGN KEY (`Pessoa_idPessoa`)
        REFERENCES `Pessoa` (`idPessoa`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE = InnoDB DEFAULT CHARSET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci;

CREATE TABLE `Especialidade` (
    `idEspecialidade` INT NOT NULL AUTO_INCREMENT,
    `nome_especialidade` VARCHAR(100) NOT NULL,
    `created_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    `updated_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (`idEspecialidade`),
    UNIQUE KEY `uk_nome_especialidade` (`nome_especialidade`)
) ENGINE = InnoDB DEFAULT CHARSET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci;

CREATE TABLE `Medico_Especialidade` (
    `Medico_Pessoa_idPessoa` INT NOT NULL,
    `Especialidade_idEspecialidade` INT NOT NULL,
    `created_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (`Medico_Pessoa_idPessoa`, `Especialidade_idEspecialidade`),
    CONSTRAINT `fk_MedEsp_Medico` FOREIGN KEY (`Medico_Pessoa_idPessoa`)
        REFERENCES `Medico` (`Pessoa_idPessoa`) ON DELETE CASCADE ON UPDATE CASCADE,
    CONSTRAINT `fk_MedEsp_Especialidade` FOREIGN KEY (`Especialidade_idEspecialidade`)
        REFERENCES `Especialidade` (`idEspecialidade`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE = InnoDB DEFAULT CHARSET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci;

CREATE TABLE `Consulta` (
    `idConsulta` INT NOT NULL AUTO_INCREMENT,
    `data_hora` DATETIME NOT NULL,
    `observacoes` LONGTEXT NULL,
    `status` VARCHAR(20) NOT NULL DEFAULT 'Agendada',
    `Paciente_Pessoa_idPessoa` INT NOT NULL,
    `Medico_Pessoa_idPessoa` INT NOT NULL,
    `created_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    `updated_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    `deleted_at` TIMESTAMP NULL,
    PRIMARY KEY (`idConsulta`),
    CONSTRAINT `fk_Consulta_Paciente` FOREIGN KEY (`Paciente_Pessoa_idPessoa`)
        REFERENCES `Paciente` (`Pessoa_idPessoa`) ON DELETE RESTRICT ON UPDATE CASCADE,
    CONSTRAINT `fk_Consulta_Medico` FOREIGN KEY (`Medico_Pessoa_idPessoa`)
        REFERENCES `Medico` (`Pessoa_idPessoa`) ON DELETE RESTRICT ON UPDATE CASCADE,
    CONSTRAINT `chk_status` CHECK (`status` IN ('Agendada', 'Realizada', 'Cancelada'))
) ENGINE = InnoDB DEFAULT CHARSET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci;

CREATE TABLE `Receita` (
    `idReceita` INT NOT NULL AUTO_INCREMENT,
    `data_emissao` DATE NOT NULL,
    `descricao_medicamentos` LONGTEXT NOT NULL,
    `dosagem` VARCHAR(100) NULL,
    `Consulta_idConsulta` INT NOT NULL,
    `created_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    `updated_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    `deleted_at` TIMESTAMP NULL,
    PRIMARY KEY (`idReceita`),
    CONSTRAINT `fk_Receita_Consulta` FOREIGN KEY (`Consulta_idConsulta`)
        REFERENCES `Consulta` (`idConsulta`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE = InnoDB DEFAULT CHARSET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci;

CREATE TABLE `Exame` (
    `idExame` INT NOT NULL AUTO_INCREMENT,
    `nome_exame` VARCHAR(100) NOT NULL,
    `data_solicitacao` DATE NOT NULL,
    `resultado` LONGTEXT NULL,
    `Consulta_idConsulta` INT NOT NULL,
    `created_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    `updated_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    `deleted_at` TIMESTAMP NULL,
    PRIMARY KEY (`idExame`),
    CONSTRAINT `fk_Exame_Consulta` FOREIGN KEY (`Consulta_idConsulta`)
        REFERENCES `Consulta` (`idConsulta`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE = InnoDB DEFAULT CHARSET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci;

CREATE TABLE `Auditoria_Consulta` (
    `idAuditoria` INT NOT NULL AUTO_INCREMENT,
    `idConsulta` INT NOT NULL,
    `acao` VARCHAR(50) NOT NULL,
    `data_acao` TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    `usuario` VARCHAR(100) NULL,
    `status_anterior` VARCHAR(20) NULL,
    `status_novo` VARCHAR(20) NULL,
    PRIMARY KEY (`idAuditoria`),
    CONSTRAINT `fk_Auditoria_Consulta` FOREIGN KEY (`idConsulta`)
        REFERENCES `Consulta` (`idConsulta`) ON DELETE CASCADE
) ENGINE = InnoDB DEFAULT CHARSET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci;

CREATE INDEX idx_paciente_pessoa ON Paciente(Pessoa_idPessoa);
CREATE INDEX idx_medico_pessoa ON Medico(Pessoa_idPessoa);
CREATE INDEX idx_funcionario_pessoa ON Funcionario(Pessoa_idPessoa);
CREATE INDEX idx_consulta_paciente ON Consulta(Paciente_Pessoa_idPessoa);
CREATE INDEX idx_consulta_medico ON Consulta(Medico_Pessoa_idPessoa);
CREATE INDEX idx_receita_consulta ON Receita(Consulta_idConsulta);
CREATE INDEX idx_exame_consulta ON Exame(Consulta_idConsulta);
CREATE INDEX idx_medico_especialidade_medico ON Medico_Especialidade(Medico_Pessoa_idPessoa);
CREATE INDEX idx_medico_especialidade_especialidade ON Medico_Especialidade(Especialidade_idEspecialidade);

CREATE UNIQUE INDEX idx_unique_cpf ON Pessoa(cpf);
CREATE UNIQUE INDEX idx_unique_crm ON Medico(crm);
CREATE INDEX idx_pessoa_nome ON Pessoa(nome);
CREATE INDEX idx_pessoa_tipo ON Pessoa(tipo);
CREATE INDEX idx_pessoa_data_nascimento ON Pessoa(data_nascimento);
CREATE INDEX idx_paciente_data_cadastro ON Paciente(data_cadastro);
CREATE INDEX idx_funcionario_cargo ON Funcionario(cargo);
CREATE INDEX idx_funcionario_data_contratacao ON Funcionario(data_contratacao);
CREATE INDEX idx_medico_especialidade ON Medico(especialidade);
CREATE INDEX idx_especialidade_nome ON Especialidade(nome_especialidade);
CREATE INDEX idx_exame_nome ON Exame(nome_exame);
CREATE INDEX idx_consulta_status ON Consulta(status);
CREATE INDEX idx_consulta_data_hora ON Consulta(data_hora);
CREATE INDEX idx_receita_data_emissao ON Receita(data_emissao);
CREATE INDEX idx_exame_data_solicitacao ON Exame(data_solicitacao);

CREATE INDEX idx_consulta_paciente_data ON Consulta(Paciente_Pessoa_idPessoa, data_hora);
CREATE INDEX idx_consulta_medico_data ON Consulta(Medico_Pessoa_idPessoa, data_hora);
CREATE INDEX idx_consulta_medico_status ON Consulta(Medico_Pessoa_idPessoa, status);
CREATE INDEX idx_consulta_paciente_status ON Consulta(Paciente_Pessoa_idPessoa, status);
CREATE INDEX idx_consulta_data_status ON Consulta(data_hora, status);
CREATE INDEX idx_medico_especialidade_crm ON Medico(especialidade, crm);

CREATE FULLTEXT INDEX idx_fulltext_consulta_observacoes ON Consulta(observacoes);
CREATE FULLTEXT INDEX idx_fulltext_paciente_historico ON Paciente(historico_medico);
CREATE FULLTEXT INDEX idx_fulltext_receita_medicamentos ON Receita(descricao_medicamentos);
CREATE FULLTEXT INDEX idx_fulltext_exame_resultado ON Exame(resultado);

CREATE INDEX idx_auditoria_consulta ON Auditoria_Consulta(idConsulta);
CREATE INDEX idx_auditoria_data_acao ON Auditoria_Consulta(data_acao);
CREATE INDEX idx_auditoria_acao ON Auditoria_Consulta(acao);

DELIMITER //
CREATE TRIGGER trg_validar_cpf_pessoa
BEFORE INSERT ON Pessoa
FOR EACH ROW
BEGIN
    IF LENGTH(NEW.cpf) != 14 OR NEW.cpf NOT REGEXP '^[0-9]{3}\.[0-9]{3}\.[0-9]{3}-[0-9]{2}$' THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'CPF inválido. Formato esperado: XXX.XXX.XXX-XX';
    END IF;
END //
DELIMITER ;

DELIMITER //
CREATE TRIGGER trg_validar_crm_medico
BEFORE INSERT ON Medico
FOR EACH ROW
BEGIN
    IF LENGTH(NEW.crm) < 4 OR LENGTH(NEW.crm) > 15 OR NEW.crm NOT REGEXP '^[A-Z0-9]+$' THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'CRM inválido. Deve ter entre 4 e 15 caracteres alfanuméricos';
    END IF;
END //
DELIMITER ;

DELIMITER //
CREATE TRIGGER trg_validar_data_consulta
BEFORE INSERT ON Consulta
FOR EACH ROW
BEGIN
    IF NEW.data_hora < NOW() THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Não é permitido agendar consultas no passado';
    END IF;
END //
DELIMITER ;

DELIMITER //
CREATE TRIGGER trg_validar_status_consulta
BEFORE INSERT ON Consulta
FOR EACH ROW
BEGIN
    IF NEW.status NOT IN ('Agendada', 'Realizada', 'Cancelada') THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Status inválido. Valores permitidos: Agendada, Realizada, Cancelada';
    END IF;
END //
DELIMITER ;

DELIMITER //
CREATE TRIGGER trg_auditoria_consulta_update
AFTER UPDATE ON Consulta
FOR EACH ROW
BEGIN
    IF OLD.status != NEW.status THEN
        INSERT INTO Auditoria_Consulta (idConsulta, acao, status_anterior, status_novo)
        VALUES (NEW.idConsulta, 'UPDATE_STATUS', OLD.status, NEW.status);
    END IF;
END //
DELIMITER ;

DELIMITER //
CREATE TRIGGER trg_prevenir_delete_consulta_realizada
BEFORE DELETE ON Consulta
FOR EACH ROW
BEGIN
    IF OLD.status = 'Realizada' THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Não é permitido deletar consultas realizadas. Use soft delete alterando deleted_at.';
    END IF;
END //
DELIMITER ;

DELIMITER //
CREATE TRIGGER trg_prevenir_consultas_simultaneas
BEFORE INSERT ON Consulta
FOR EACH ROW
BEGIN
    DECLARE consulta_existente INT;
    
    SELECT COUNT(*) INTO consulta_existente
    FROM Consulta
    WHERE Medico_Pessoa_idPessoa = NEW.Medico_Pessoa_idPessoa
    AND DATE(data_hora) = DATE(NEW.data_hora)
    AND HOUR(data_hora) = HOUR(NEW.data_hora)
    AND status != 'Cancelada'
    AND deleted_at IS NULL;
    
    IF consulta_existente > 0 THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Médico já possui uma consulta agendada neste horário';
    END IF;
END //
DELIMITER ;

DELIMITER //
CREATE TRIGGER trg_validar_data_nascimento
BEFORE INSERT ON Pessoa
FOR EACH ROW
BEGIN
    DECLARE idade INT;
    
    IF NEW.data_nascimento > CURDATE() THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Data de nascimento não pode ser no futuro';
    END IF;
    
    SET idade = YEAR(CURDATE()) - YEAR(NEW.data_nascimento);
    IF MONTH(CURDATE()) < MONTH(NEW.data_nascimento) OR 
       (MONTH(CURDATE()) = MONTH(NEW.data_nascimento) AND DAY(CURDATE()) < DAY(NEW.data_nascimento)) THEN
        SET idade = idade - 1;
    END IF;
    
    IF idade < 0 THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Idade inválida. Verifique a data de nascimento';
    END IF;
END //
DELIMITER ;

CREATE OR REPLACE VIEW vw_consultas_ativas AS
SELECT 
    c.idConsulta,
    c.data_hora,
    p.nome AS paciente_nome,
    p.cpf AS paciente_cpf,
    p.telefone AS paciente_telefone,
    m_p.nome AS medico_nome,
    m.crm,
    m.especialidade,
    c.status,
    c.observacoes,
    c.created_at
FROM Consulta c
JOIN Paciente pac ON c.Paciente_Pessoa_idPessoa = pac.Pessoa_idPessoa
JOIN Pessoa p ON pac.Pessoa_idPessoa = p.idPessoa
JOIN Medico m ON c.Medico_Pessoa_idPessoa = m.Pessoa_idPessoa
JOIN Pessoa m_p ON m.Pessoa_idPessoa = m_p.idPessoa
WHERE c.deleted_at IS NULL AND p.deleted_at IS NULL AND m_p.deleted_at IS NULL
ORDER BY c.data_hora DESC;

CREATE OR REPLACE VIEW vw_medico_com_especialidades AS
SELECT 
    m.Pessoa_idPessoa,
    p.nome,
    m.crm,
    m.especialidade,
    GROUP_CONCAT(e.nome_especialidade SEPARATOR ', ') AS especialidades,
    COUNT(e.idEspecialidade) AS total_especialidades
FROM Medico m
JOIN Pessoa p ON m.Pessoa_idPessoa = p.idPessoa
LEFT JOIN Medico_Especialidade me ON m.Pessoa_idPessoa = me.Medico_Pessoa_idPessoa
LEFT JOIN Especialidade e ON me.Especialidade_idEspecialidade = e.idEspecialidade
WHERE p.deleted_at IS NULL
GROUP BY m.Pessoa_idPessoa, p.nome, m.crm, m.especialidade;

CREATE OR REPLACE VIEW vw_agenda_medico AS
SELECT 
    c.idConsulta,
    c.data_hora,
    DATE(c.data_hora) AS data,
    HOUR(c.data_hora) AS hora,
    p.nome AS paciente_nome,
    p.cpf AS paciente_cpf,
    p.telefone AS paciente_telefone,
    m.Pessoa_idPessoa AS medico_id,
    m_p.nome AS medico_nome,
    m.crm,
    c.status
FROM Consulta c
JOIN Paciente pac ON c.Paciente_Pessoa_idPessoa = pac.Pessoa_idPessoa
JOIN Pessoa p ON pac.Pessoa_idPessoa = p.idPessoa
JOIN Medico m ON c.Medico_Pessoa_idPessoa = m.Pessoa_idPessoa
JOIN Pessoa m_p ON m.Pessoa_idPessoa = m_p.idPessoa
WHERE c.deleted_at IS NULL AND c.status != 'Cancelada'
ORDER BY c.data_hora ASC;

CREATE OR REPLACE VIEW vw_historico_paciente AS
SELECT 
    c.idConsulta,
    c.data_hora,
    m_p.nome AS medico_nome,
    m.crm,
    m.especialidade,
    c.status,
    c.observacoes,
    COUNT(DISTINCT r.idReceita) AS total_receitas,
    COUNT(DISTINCT e.idExame) AS total_exames
FROM Consulta c
JOIN Medico m ON c.Medico_Pessoa_idPessoa = m.Pessoa_idPessoa
JOIN Pessoa m_p ON m.Pessoa_idPessoa = m_p.idPessoa
LEFT JOIN Receita r ON c.idConsulta = r.Consulta_idConsulta AND r.deleted_at IS NULL
LEFT JOIN Exame e ON c.idConsulta = e.Consulta_idConsulta AND e.deleted_at IS NULL
WHERE c.deleted_at IS NULL
GROUP BY c.idConsulta
ORDER BY c.data_hora DESC;

DELIMITER //
CREATE PROCEDURE registrar_consulta_completa(
    IN p_paciente_id INT,
    IN p_medico_id INT,
    IN p_data_hora DATETIME,
    IN p_observacoes TEXT,
    IN p_medicamentos TEXT,
    IN p_dosagem VARCHAR(100),
    IN p_nome_exame VARCHAR(100)
)
BEGIN
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        ROLLBACK;
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Erro ao registrar consulta completa. Transação desfeita.';
    END;
    
    START TRANSACTION;
    
        INSERT INTO Consulta (data_hora, observacoes, status, Paciente_Pessoa_idPessoa, Medico_Pessoa_idPessoa)
        VALUES (p_data_hora, p_observacoes, 'Realizada', p_paciente_id, p_medico_id);
        
        SET @idConsulta = LAST_INSERT_ID();
        
        INSERT INTO Receita (data_emissao, descricao_medicamentos, dosagem, Consulta_idConsulta)
        VALUES (CURDATE(), p_medicamentos, p_dosagem, @idConsulta);
        
        INSERT INTO Exame (nome_exame, data_solicitacao, Consulta_idConsulta)
        VALUES (p_nome_exame, CURDATE(), @idConsulta);
        
        COMMIT;
        
        SELECT 'Consulta registrada com sucesso!' AS mensagem, @idConsulta AS id_consulta;
END //
DELIMITER ;

DELIMITER //
CREATE PROCEDURE atualizar_status_consulta(
    IN p_id_consulta INT,
    IN p_novo_status VARCHAR(20)
)
BEGIN
    DECLARE v_status_atual VARCHAR(20);
    DECLARE v_paciente_id INT;
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        ROLLBACK;
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Erro ao atualizar status da consulta.';
    END;
    
    START TRANSACTION;
    
        SELECT status, Paciente_Pessoa_idPessoa INTO v_status_atual, v_paciente_id
        FROM Consulta
        WHERE idConsulta = p_id_consulta;
        
        IF v_status_atual IS NULL THEN
            SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Consulta não encontrada.';
        END IF;
        
        IF v_status_atual = 'Cancelada' THEN
            SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Não é permitido alterar uma consulta cancelada.';
        END IF;
        
        IF v_status_atual = 'Realizada' AND p_novo_status = 'Agendada' THEN
            SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Não é permitido reverter uma consulta realizada para agendada.';
        END IF;
        
        UPDATE Consulta
        SET status = p_novo_status
        WHERE idConsulta = p_id_consulta;
        
        INSERT INTO Auditoria_Consulta (idConsulta, acao, status_anterior, status_novo)
        VALUES (p_id_consulta, 'UPDATE', v_status_atual, p_novo_status);
        
        COMMIT;
        
        SELECT 'Status atualizado com sucesso!' AS mensagem;
END //
DELIMITER ;

DELIMITER //
CREATE PROCEDURE registrar_novo_paciente(
    IN p_nome VARCHAR(100),
    IN p_cpf VARCHAR(14),
    IN p_data_nascimento DATE,
    IN p_telefone VARCHAR(20),
    IN p_endereco VARCHAR(255),
    IN p_historico_medico TEXT
)
BEGIN
    DECLARE v_id_pessoa INT;
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        ROLLBACK;
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Erro ao registrar novo paciente. Transação desfeita.';
    END;
    
    START TRANSACTION;
    
        INSERT INTO Pessoa (nome, cpf, data_nascimento, telefone, endereco, tipo)
        VALUES (p_nome, p_cpf, p_data_nascimento, p_telefone, p_endereco, 'Paciente');
        
        SET v_id_pessoa = LAST_INSERT_ID();
        
        INSERT INTO Paciente (Pessoa_idPessoa, historico_medico, data_cadastro)
        VALUES (v_id_pessoa, p_historico_medico, CURDATE());
        
        COMMIT;
        
        SELECT 'Paciente registrado com sucesso!' AS mensagem, v_id_pessoa AS id_paciente;
END //
DELIMITER ;

DELIMITER //
CREATE PROCEDURE registrar_novo_medico(
    IN p_nome VARCHAR(100),
    IN p_cpf VARCHAR(14),
    IN p_crm VARCHAR(15),
    IN p_especialidade_principal VARCHAR(100),
    IN p_especialidades_ids VARCHAR(500)
)
BEGIN
    DECLARE v_id_pessoa INT;
    DECLARE v_i INT DEFAULT 0;
    DECLARE v_especialidade_id INT;
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        ROLLBACK;
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Erro ao registrar novo médico. Transação desfeita.';
    END;
    
    START TRANSACTION;
    
        INSERT INTO Pessoa (nome, cpf, data_nascimento, telefone, endereco, tipo)
        VALUES (p_nome, p_cpf, NULL, NULL, NULL, 'Médico');
        
        SET v_id_pessoa = LAST_INSERT_ID();
        
        INSERT INTO Medico (Pessoa_idPessoa, crm, especialidade)
        VALUES (v_id_pessoa, p_crm, p_especialidade_principal);
        
        IF p_especialidades_ids IS NOT NULL THEN
            SET v_i = 0;
            WHILE v_i < JSON_LENGTH(p_especialidades_ids) DO
                SET v_especialidade_id = JSON_EXTRACT(p_especialidades_ids, CONCAT('$[', v_i, ']'));
                INSERT INTO Medico_Especialidade (Medico_Pessoa_idPessoa, Especialidade_idEspecialidade)
                VALUES (v_id_pessoa, v_especialidade_id);
                SET v_i = v_i + 1;
            END WHILE;
        END IF;
        
        COMMIT;
        
        SELECT 'Médico registrado com sucesso!' AS mensagem, v_id_pessoa AS id_medico;
END //
DELIMITER ;

DELIMITER //
CREATE PROCEDURE cancelar_consulta(
    IN p_id_consulta INT,
    IN p_motivo TEXT
)
BEGIN
    DECLARE v_status_atual VARCHAR(20);
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        ROLLBACK;
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Erro ao cancelar consulta.';
    END;
    
    START TRANSACTION;
    
        SELECT status INTO v_status_atual
        FROM Consulta
        WHERE idConsulta = p_id_consulta;
        
        IF v_status_atual = 'Realizada' THEN
            SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Não é permitido cancelar uma consulta já realizada.';
        END IF;
        
        UPDATE Consulta
        SET status = 'Cancelada'
        WHERE idConsulta = p_id_consulta;
        
        INSERT INTO Auditoria_Consulta (idConsulta, acao, status_anterior, status_novo)
        VALUES (p_id_consulta, 'CANCEL', v_status_atual, 'Cancelada');
        
        UPDATE Receita
        SET deleted_at = CURRENT_TIMESTAMP
        WHERE Consulta_idConsulta = p_id_consulta;
        
        UPDATE Exame
        SET deleted_at = CURRENT_TIMESTAMP
        WHERE Consulta_idConsulta = p_id_consulta;
        
        COMMIT;
        
        SELECT 'Consulta cancelada com sucesso!' AS mensagem;
END //
DELIMITER ;

DELIMITER //
CREATE PROCEDURE transferir_consulta(
    IN p_id_consulta INT,
    IN p_novo_medico_id INT
)
BEGIN
    DECLARE v_medico_anterior INT;
    DECLARE v_status_consulta VARCHAR(20);
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        ROLLBACK;
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Erro ao transferir consulta.';
    END;
    
    START TRANSACTION;
    
        SELECT Medico_Pessoa_idPessoa, status INTO v_medico_anterior, v_status_consulta
        FROM Consulta
        WHERE idConsulta = p_id_consulta;
        
        IF v_medico_anterior IS NULL THEN
            SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Consulta não encontrada.';
        END IF;
        
        IF v_status_consulta = 'Realizada' THEN
            SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Não é permitido transferir uma consulta já realizada.';
        END IF;
        
        IF NOT EXISTS (SELECT 1 FROM Medico WHERE Pessoa_idPessoa = p_novo_medico_id) THEN
            SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Médico de destino não encontrado.';
        END IF;
        
        UPDATE Consulta
        SET Medico_Pessoa_idPessoa = p_novo_medico_id
        WHERE idConsulta = p_id_consulta;
        
        INSERT INTO Auditoria_Consulta (idConsulta, acao, status_anterior, status_novo)
        VALUES (p_id_consulta, 'TRANSFER', CONCAT('Médico: ', v_medico_anterior), CONCAT('Médico: ', p_novo_medico_id));
        
        COMMIT;
        
        SELECT 'Consulta transferida com sucesso!' AS mensagem;
END //
DELIMITER ;

DELIMITER //
CREATE PROCEDURE atualizar_dados_paciente(
    IN p_paciente_id INT,
    IN p_novo_telefone VARCHAR(20),
    IN p_novo_endereco VARCHAR(255),
    IN p_novo_historico TEXT
)
BEGIN
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        ROLLBACK;
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Erro ao atualizar dados do paciente.';
    END;
    
    START TRANSACTION;
    
        IF NOT EXISTS (SELECT 1 FROM Paciente WHERE Pessoa_idPessoa = p_paciente_id) THEN
            SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Paciente não encontrado.';
        END IF;
        
        UPDATE Pessoa
        SET telefone = p_novo_telefone,
            endereco = p_novo_endereco
        WHERE idPessoa = p_paciente_id;
        
        UPDATE Paciente
        SET historico_medico = p_novo_historico
        WHERE Pessoa_idPessoa = p_paciente_id;
        
        COMMIT;
        
        SELECT 'Dados do paciente atualizados com sucesso!' AS mensagem;
END //
DELIMITER ;

SET FOREIGN_KEY_CHECKS = 1;

INSERT INTO Especialidade (nome_especialidade) VALUES
('Cardiologia'),
('Dermatologia'),
('Oftalmologia'),
('Pediatria'),
('Psiquiatria'),
('Ortopedia'),
('Neurologia'),
('Gastroenterologia');

INSERT INTO Pessoa (nome, cpf, data_nascimento, telefone, endereco, tipo) VALUES
('João Silva', '123.456.789-10', '1990-05-15', '11999999999', 'Rua A, 123', 'Paciente'),
('Maria Santos', '987.654.321-00', '1985-03-20', '11988888888', 'Rua B, 456', 'Paciente'),
('Ana Costa', '456.789.123-45', '1995-08-10', '11987654321', 'Avenida C, 789', 'Paciente');

INSERT INTO Paciente (Pessoa_idPessoa, historico_medico, data_cadastro) VALUES
(1, 'Sem alergias conhecidas. Pressão arterial normal.', CURDATE()),
(2, 'Alérgico a penicilina. Histórico de asma.', CURDATE()),
(3, 'Diabético tipo 2. Toma metformina regularmente.', CURDATE());

INSERT INTO Pessoa (nome, cpf, data_nascimento, telefone, endereco, tipo) VALUES
('Dr. Carlos Santos', '111.222.333-44', '1970-01-15', '11987654321', 'Rua D, 1000', 'Médico'),
('Dra. Paula Oliveira', '222.333.444-55', '1975-06-20', '11986543210', 'Rua E, 2000', 'Médico');

INSERT INTO Medico (Pessoa_idPessoa, crm, especialidade) VALUES
(4, 'CRM123456', 'Cardiologia'),
(5, 'CRM654321', 'Dermatologia');

INSERT INTO Medico_Especialidade (Medico_Pessoa_idPessoa, Especialidade_idEspecialidade) VALUES
(4, 1),
(4, 7),
(5, 2),
(5, 4);

INSERT INTO Pessoa (nome, cpf, data_nascimento, telefone, endereco, tipo) VALUES
('Recepcionista Ana', '333.444.555-66', '1992-12-10', '11985432109', 'Rua F, 3000', 'Funcionário'),
('Enfermeiro João', '444.555.666-77', '1988-07-25', '11984321098', 'Rua G, 4000', 'Funcionário');

INSERT INTO Funcionario (Pessoa_idPessoa, cargo, data_contratacao) VALUES
(6, 'Recepcionista', '2023-01-15'),
(7, 'Enfermeiro', '2022-06-01');

INSERT INTO Consulta (data_hora, observacoes, status, Paciente_Pessoa_idPessoa, Medico_Pessoa_idPessoa) VALUES
('2024-12-20 10:00:00', 'Consulta de rotina. Paciente apresenta sintomas de gripe.', 'Agendada', 1, 4),
('2024-12-21 14:30:00', 'Avaliação de alergias na pele.', 'Realizada', 2, 5),
('2024-12-22 09:00:00', 'Acompanhamento de diabetes.', 'Agendada', 3, 4);

INSERT INTO Receita (data_emissao, descricao_medicamentos, dosagem, Consulta_idConsulta) VALUES
(CURDATE(), 'Dipirona 500mg, Amoxicilina 500mg', '1 comprimido a cada 8 horas', 2),
(CURDATE(), 'Metformina 850mg', '1 comprimido duas vezes ao dia', 3);

INSERT INTO Exame (nome_exame, data_solicitacao, Consulta_idConsulta) VALUES
('Raio-X de tórax', CURDATE(), 1),
('Teste de alergia', CURDATE(), 2),
('Glicemia em jejum', CURDATE(), 3);
