<?php

declare(strict_types=1);

namespace DoctrineMigrations;

use Doctrine\DBAL\Schema\Schema;
use Doctrine\Migrations\AbstractMigration;

/**
 * Auto-generated Migration: Please modify to your needs!
 */
final class Version20250421163642 extends AbstractMigration
{
    public function getDescription(): string
    {
        return '';
    }

    public function up(Schema $schema): void
    {
        // this up() migration is auto-generated, please modify it to your needs
        $this->addSql(<<<'SQL'
            CREATE TABLE actor (id INT AUTO_INCREMENT NOT NULL, name VARCHAR(255) NOT NULL, PRIMARY KEY(id)) DEFAULT CHARACTER SET utf8mb4 COLLATE `utf8mb4_unicode_ci` ENGINE = InnoDB
        SQL);
        $this->addSql(<<<'SQL'
            CREATE TABLE dream (id INT AUTO_INCREMENT NOT NULL, title VARCHAR(255) NOT NULL, content LONGTEXT NOT NULL, feeling LONGTEXT NOT NULL, PRIMARY KEY(id)) DEFAULT CHARACTER SET utf8mb4 COLLATE `utf8mb4_unicode_ci` ENGINE = InnoDB
        SQL);
        $this->addSql(<<<'SQL'
            CREATE TABLE dream_actor (dream_id INT NOT NULL, actor_id INT NOT NULL, INDEX IDX_E66D53DEE65343C2 (dream_id), INDEX IDX_E66D53DE10DAF24A (actor_id), PRIMARY KEY(dream_id, actor_id)) DEFAULT CHARACTER SET utf8mb4 COLLATE `utf8mb4_unicode_ci` ENGINE = InnoDB
        SQL);
        $this->addSql(<<<'SQL'
            CREATE TABLE dream_location (dream_id INT NOT NULL, location_id INT NOT NULL, INDEX IDX_D87B51FE65343C2 (dream_id), INDEX IDX_D87B51F64D218E (location_id), PRIMARY KEY(dream_id, location_id)) DEFAULT CHARACTER SET utf8mb4 COLLATE `utf8mb4_unicode_ci` ENGINE = InnoDB
        SQL);
        $this->addSql(<<<'SQL'
            CREATE TABLE location (id INT AUTO_INCREMENT NOT NULL, name VARCHAR(255) NOT NULL, PRIMARY KEY(id)) DEFAULT CHARACTER SET utf8mb4 COLLATE `utf8mb4_unicode_ci` ENGINE = InnoDB
        SQL);
        $this->addSql(<<<'SQL'
            ALTER TABLE dream_actor ADD CONSTRAINT FK_E66D53DEE65343C2 FOREIGN KEY (dream_id) REFERENCES dream (id) ON DELETE CASCADE
        SQL);
        $this->addSql(<<<'SQL'
            ALTER TABLE dream_actor ADD CONSTRAINT FK_E66D53DE10DAF24A FOREIGN KEY (actor_id) REFERENCES actor (id) ON DELETE CASCADE
        SQL);
        $this->addSql(<<<'SQL'
            ALTER TABLE dream_location ADD CONSTRAINT FK_D87B51FE65343C2 FOREIGN KEY (dream_id) REFERENCES dream (id) ON DELETE CASCADE
        SQL);
        $this->addSql(<<<'SQL'
            ALTER TABLE dream_location ADD CONSTRAINT FK_D87B51F64D218E FOREIGN KEY (location_id) REFERENCES location (id) ON DELETE CASCADE
        SQL);
    }

    public function down(Schema $schema): void
    {
        // this down() migration is auto-generated, please modify it to your needs
        $this->addSql(<<<'SQL'
            ALTER TABLE dream_actor DROP FOREIGN KEY FK_E66D53DEE65343C2
        SQL);
        $this->addSql(<<<'SQL'
            ALTER TABLE dream_actor DROP FOREIGN KEY FK_E66D53DE10DAF24A
        SQL);
        $this->addSql(<<<'SQL'
            ALTER TABLE dream_location DROP FOREIGN KEY FK_D87B51FE65343C2
        SQL);
        $this->addSql(<<<'SQL'
            ALTER TABLE dream_location DROP FOREIGN KEY FK_D87B51F64D218E
        SQL);
        $this->addSql(<<<'SQL'
            DROP TABLE actor
        SQL);
        $this->addSql(<<<'SQL'
            DROP TABLE dream
        SQL);
        $this->addSql(<<<'SQL'
            DROP TABLE dream_actor
        SQL);
        $this->addSql(<<<'SQL'
            DROP TABLE dream_location
        SQL);
        $this->addSql(<<<'SQL'
            DROP TABLE location
        SQL);
    }
}
