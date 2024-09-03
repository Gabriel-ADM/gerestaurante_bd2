-- MySQL Workbench Forward Engineering

SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0;
SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0;
SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION';

-- -----------------------------------------------------
-- Schema mydb
-- -----------------------------------------------------
-- -----------------------------------------------------
-- Schema gerestaurante
-- -----------------------------------------------------

-- -----------------------------------------------------
-- Table `funcionario`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `funcionario` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `nome` VARCHAR(70) NOT NULL,
  `email` VARCHAR(35) NULL DEFAULT NULL,
  `remuneracao` DECIMAL(6,2) NULL DEFAULT '0.00',
  `data_admissao` TIMESTAMP NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE INDEX `email` (`email` ASC) VISIBLE)
ENGINE = InnoDB
AUTO_INCREMENT = 7
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_0900_ai_ci;


-- -----------------------------------------------------
-- Table `tarefa`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `tarefa` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `prazo_final` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `data_criacao` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `descricao` VARCHAR(1200) NULL DEFAULT NULL,
  `nome` VARCHAR(70) NULL DEFAULT NULL,
  PRIMARY KEY (`id`))
ENGINE = InnoDB
AUTO_INCREMENT = 3
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_0900_ai_ci;


-- -----------------------------------------------------
-- Table `atribuicao_tarefa`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `atribuicao_tarefa` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `estado` VARCHAR(50) NULL DEFAULT NULL,
  `funcionario_id` INT NULL DEFAULT NULL,
  `tarefa_id` INT NULL DEFAULT NULL,
  `data_atribuicao` TIMESTAMP NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  INDEX `funcionario_id` (`funcionario_id` ASC) VISIBLE,
  INDEX `tarefa_id` (`tarefa_id` ASC) VISIBLE,
  CONSTRAINT `atribuicao_tarefa_ibfk_1`
    FOREIGN KEY (`funcionario_id`)
    REFERENCES `funcionario` (`id`),
  CONSTRAINT `atribuicao_tarefa_ibfk_2`
    FOREIGN KEY (`tarefa_id`)
    REFERENCES `tarefa` (`id`))
ENGINE = InnoDB
AUTO_INCREMENT = 2
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_0900_ai_ci;


-- -----------------------------------------------------
-- Table `cliente`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `cliente` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `nome` VARCHAR(70) NOT NULL,
  `email` VARCHAR(35) NULL DEFAULT NULL,
  `data_criacao` TIMESTAMP NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE INDEX `email` (`email` ASC) VISIBLE)
ENGINE = InnoDB
AUTO_INCREMENT = 14
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_0900_ai_ci;


-- -----------------------------------------------------
-- Table `endereco`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `endereco` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `cep` VARCHAR(11) NOT NULL,
  `uf` VARCHAR(2) NOT NULL,
  `cidade` VARCHAR(30) NULL DEFAULT NULL,
  `logradouro` VARCHAR(50) NULL DEFAULT NULL,
  `numero` INT NULL DEFAULT '1',
  `cliente_id` INT NULL DEFAULT NULL,
  `funcionario_id` INT NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  INDEX `cliente_id` (`cliente_id` ASC) VISIBLE,
  INDEX `funcionario_id` (`funcionario_id` ASC) VISIBLE,
  CONSTRAINT `endereco_ibfk_1`
    FOREIGN KEY (`cliente_id`)
    REFERENCES `cliente` (`id`)
    ON DELETE CASCADE,
  CONSTRAINT `endereco_ibfk_2`
    FOREIGN KEY (`funcionario_id`)
    REFERENCES `funcionario` (`id`)
    ON DELETE CASCADE)
ENGINE = InnoDB
AUTO_INCREMENT = 4
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_0900_ai_ci;


-- -----------------------------------------------------
-- Table `estoque`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `estoque` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `nome` VARCHAR(45) NULL DEFAULT NULL,
  `descricao` VARCHAR(800) NULL DEFAULT NULL,
  `quantidade` INT NOT NULL DEFAULT '0',
  `quantidade_ideal` INT NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`))
ENGINE = InnoDB
AUTO_INCREMENT = 10
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_0900_ai_ci;


-- -----------------------------------------------------
-- Table `produto`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `produto` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `nome` VARCHAR(50) NOT NULL,
  `receita` VARCHAR(600) NULL DEFAULT NULL,
  `custo` DECIMAL(6,2) NOT NULL DEFAULT '0.00',
  `valor` INT NULL DEFAULT '0',
  PRIMARY KEY (`id`))
ENGINE = InnoDB
AUTO_INCREMENT = 8
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_0900_ai_ci;


-- -----------------------------------------------------
-- Table `movimentacao_estoque`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `movimentacao_estoque` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `data_movimentacao` TIMESTAMP NULL DEFAULT CURRENT_TIMESTAMP,
  `quantidade_movimentada` INT NOT NULL DEFAULT '1',
  `tipo_movimentacao` VARCHAR(50) NULL DEFAULT NULL,
  `produto_id` INT NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  INDEX `produto_id` (`produto_id` ASC) VISIBLE,
  CONSTRAINT `movimentacao_estoque_ibfk_1`
    FOREIGN KEY (`produto_id`)
    REFERENCES `produto` (`id`))
ENGINE = InnoDB
AUTO_INCREMENT = 23
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_0900_ai_ci;


-- -----------------------------------------------------
-- Table `pedido`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `pedido` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `data_pedido` TIMESTAMP NULL DEFAULT CURRENT_TIMESTAMP,
  `descricao` VARCHAR(1200) NOT NULL,
  `estado` VARCHAR(35) NULL DEFAULT NULL,
  `cliente_id` INT NULL DEFAULT NULL,
  `funcionario_id` INT NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  INDEX `cliente_id` (`cliente_id` ASC) VISIBLE,
  INDEX `funcionario_id` (`funcionario_id` ASC) VISIBLE,
  CONSTRAINT `pedido_ibfk_1`
    FOREIGN KEY (`cliente_id`)
    REFERENCES `cliente` (`id`),
  CONSTRAINT `pedido_ibfk_2`
    FOREIGN KEY (`funcionario_id`)
    REFERENCES `funcionario` (`id`))
ENGINE = InnoDB
AUTO_INCREMENT = 14
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_0900_ai_ci;


-- -----------------------------------------------------
-- Table `produtos_pedidos`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `produtos_pedidos` (
  `produto_id` INT NOT NULL,
  `pedido_id` INT NOT NULL,
  `quantidade` INT NULL DEFAULT '1',
  PRIMARY KEY (`produto_id`, `pedido_id`),
  INDEX `pedido_id` (`pedido_id` ASC) VISIBLE,
  CONSTRAINT `produtos_pedidos_ibfk_1`
    FOREIGN KEY (`produto_id`)
    REFERENCES `produto` (`id`)
    ON DELETE CASCADE,
  CONSTRAINT `produtos_pedidos_ibfk_2`
    FOREIGN KEY (`pedido_id`)
    REFERENCES `pedido` (`id`)
    ON DELETE CASCADE)
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_0900_ai_ci;


-- -----------------------------------------------------
-- Table `telefone`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `telefone` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `pessoa_id` INT NULL DEFAULT NULL,
  `pessoa_tipo` VARCHAR(35) NULL DEFAULT NULL,
  `telefone` VARCHAR(20) NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  INDEX `pessoa_id` (`pessoa_id` ASC) VISIBLE,
  CONSTRAINT `telefone_ibfk_1`
    FOREIGN KEY (`pessoa_id`)
    REFERENCES `cliente` (`id`)
    ON DELETE CASCADE,
  CONSTRAINT `telefone_ibfk_2`
    FOREIGN KEY (`pessoa_id`)
    REFERENCES `funcionario` (`id`)
    ON DELETE CASCADE)
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_0900_ai_ci;


-- -----------------------------------------------------
-- Placeholder table for view `pedido_completo`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `pedido_completo` (`id` INT);

-- -----------------------------------------------------
-- Placeholder table for view `tarefa_funcionario`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `tarefa_funcionario` (`funcionario_id` INT, `funcionario_nome` INT, `tarefa_id` INT, `estado_tarefa` INT, `data_criacao_tarefa` INT, `data_atribuicao` INT, `descricao` INT, `prazo_final` INT);

-- -----------------------------------------------------
-- procedure ExpirarTarefasAtrasadas
-- -----------------------------------------------------

DELIMITER $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `ExpirarTarefasAtrasadas`()
BEGIN
    UPDATE atribuicao_tarefa atf
    JOIN tarefa t ON atf.tarefa_id = t.id
    SET atf.status = 'atrasada'
    WHERE t.prazo_final < CURDATE()
    AND atf.status != 'atrasada';
END$$

DELIMITER ;

-- -----------------------------------------------------
-- View `pedido_completo`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `pedido_completo`;
CREATE  OR REPLACE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `gerestaurante`.`pedido_completo` AS select `ped`.`id` AS `pedido_id`,`ped`.`data_pedido` AS `data_pedido`,`ped`.`descricao` AS `descricao`,`ped`.`estado` AS `estado`,`ped`.`cliente_id` AS `cliente_id`,`ped`.`funcionario_id` AS `funcionario_id`,`prd`.`id` AS `produto_id`,`prd`.`nome` AS `nome`,`pp`.`quantidade` AS `quantidade`,`prd`.`custo` AS `custo`,`prd`.`valor` AS `valor`,sum((`prd`.`custo` * `pp`.`quantidade`)) OVER (PARTITION BY `ped`.`id` )  AS `custo_total`,sum((`prd`.`valor` * `pp`.`quantidade`)) OVER (PARTITION BY `ped`.`id` )  AS `valor_total` from ((`gerestaurante`.`pedido` `ped` join `gerestaurante`.`produtos_pedidos` `pp` on((`ped`.`id` = `pp`.`pedido_id`))) join `gerestaurante`.`produto` `prd` on((`pp`.`produto_id` = `prd`.`id`)));

-- -----------------------------------------------------
-- View `tarefa_funcionario`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `tarefa_funcionario`;
CREATE  OR REPLACE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `tarefa_funcionario` AS select `fn`.`id` AS `funcionario_id`,`fn`.`nome` AS `funcionario_nome`,`tf`.`id` AS `tarefa_id`,`atf`.`estado` AS `estado_tarefa`,`tf`.`data_criacao` AS `data_criacao_tarefa`,`atf`.`data_atribuicao` AS `data_atribuicao`,`tf`.`descricao` AS `descricao`,`tf`.`prazo_final` AS `prazo_final` from ((`funcionario` `fn` join `atribuicao_tarefa` `atf` on((`atf`.`funcionario_id` = `fn`.`id`))) join `tarefa` `tf` on((`tf`.`id` = `atf`.`tarefa_id`)));

DELIMITER $$
CREATE
DEFINER=`root`@`localhost`
TRIGGER `gerestaurante`.`atualiza_estoque_quantidade`
AFTER INSERT ON `gerestaurante`.`movimentacao_estoque`
FOR EACH ROW
BEGIN
    IF NEW.tipo_movimentacao = 'utilizacao' THEN
        UPDATE estoque
        SET quantidade = quantidade - NEW.quantidade_movimentada
        WHERE id = NEW.produto_id;
    ELSEIF NEW.tipo_movimentacao = 'reposicao' THEN
        UPDATE estoque
        SET quantidade = quantidade + NEW.quantidade_movimentada
        WHERE id = NEW.produto_id;
    END IF;
END$$

CREATE
DEFINER=`root`@`localhost`
TRIGGER `gerestaurante`.`atualiza_estoque_pos_pedido`
AFTER INSERT ON `gerestaurante`.`produtos_pedidos`
FOR EACH ROW
BEGIN
    insert into movimentacao_estoque (tipo_movimentacao, quantidade_movimentada, produto_id) 
    values ('utilizacao', NEW.quantidade, NEW.produto_id);
END$$


DELIMITER ;

SET SQL_MODE=@OLD_SQL_MODE;
SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;
SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS;
