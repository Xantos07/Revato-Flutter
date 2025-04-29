<?php

declare(strict_types=1);

namespace DoctrineMigrations;

use Doctrine\DBAL\Schema\Schema;
use Doctrine\Migrations\AbstractMigration;

/**
 * Auto-generated Migration: Please modify to your needs!
 */
final class Version20250429090555 extends AbstractMigration
{
    public function getDescription(): string
    {
        return '';
    }

    public function up(Schema $schema): void
    {
        // this up() migration is auto-generated, please modify it to your needs
        $this->addSql(<<<'SQL'
            CREATE TABLE dream_tags_before_event (dream_id INT NOT NULL, tag_id INT NOT NULL, INDEX IDX_46028FEFE65343C2 (dream_id), INDEX IDX_46028FEFBAD26311 (tag_id), PRIMARY KEY(dream_id, tag_id)) DEFAULT CHARACTER SET utf8mb4 COLLATE `utf8mb4_unicode_ci` ENGINE = InnoDB
        SQL);
        $this->addSql(<<<'SQL'
            CREATE TABLE dream_tags_before_feeling (dream_id INT NOT NULL, tag_id INT NOT NULL, INDEX IDX_C7CD05BDE65343C2 (dream_id), INDEX IDX_C7CD05BDBAD26311 (tag_id), PRIMARY KEY(dream_id, tag_id)) DEFAULT CHARACTER SET utf8mb4 COLLATE `utf8mb4_unicode_ci` ENGINE = InnoDB
        SQL);
        $this->addSql(<<<'SQL'
            CREATE TABLE dream_tags_dream_feeling (dream_id INT NOT NULL, tag_id INT NOT NULL, INDEX IDX_DBCC071EE65343C2 (dream_id), INDEX IDX_DBCC071EBAD26311 (tag_id), PRIMARY KEY(dream_id, tag_id)) DEFAULT CHARACTER SET utf8mb4 COLLATE `utf8mb4_unicode_ci` ENGINE = InnoDB
        SQL);
        $this->addSql(<<<'SQL'
            CREATE TABLE tag (id INT AUTO_INCREMENT NOT NULL, name VARCHAR(255) DEFAULT NULL, PRIMARY KEY(id)) DEFAULT CHARACTER SET utf8mb4 COLLATE `utf8mb4_unicode_ci` ENGINE = InnoDB
        SQL);
        $this->addSql(<<<'SQL'
            ALTER TABLE dream_tags_before_event ADD CONSTRAINT FK_46028FEFE65343C2 FOREIGN KEY (dream_id) REFERENCES dream (id) ON DELETE CASCADE
        SQL);
        $this->addSql(<<<'SQL'
            ALTER TABLE dream_tags_before_event ADD CONSTRAINT FK_46028FEFBAD26311 FOREIGN KEY (tag_id) REFERENCES tag (id) ON DELETE CASCADE
        SQL);
        $this->addSql(<<<'SQL'
            ALTER TABLE dream_tags_before_feeling ADD CONSTRAINT FK_C7CD05BDE65343C2 FOREIGN KEY (dream_id) REFERENCES dream (id) ON DELETE CASCADE
        SQL);
        $this->addSql(<<<'SQL'
            ALTER TABLE dream_tags_before_feeling ADD CONSTRAINT FK_C7CD05BDBAD26311 FOREIGN KEY (tag_id) REFERENCES tag (id) ON DELETE CASCADE
        SQL);
        $this->addSql(<<<'SQL'
            ALTER TABLE dream_tags_dream_feeling ADD CONSTRAINT FK_DBCC071EE65343C2 FOREIGN KEY (dream_id) REFERENCES dream (id) ON DELETE CASCADE
        SQL);
        $this->addSql(<<<'SQL'
            ALTER TABLE dream_tags_dream_feeling ADD CONSTRAINT FK_DBCC071EBAD26311 FOREIGN KEY (tag_id) REFERENCES tag (id) ON DELETE CASCADE
        SQL);
        $this->addSql(<<<'SQL'
            ALTER TABLE dream DROP tags_before_event, DROP tags_before_feeling, DROP tags_dream_feeling
        SQL);
    }

    public function down(Schema $schema): void
    {
        // this down() migration is auto-generated, please modify it to your needs
        $this->addSql(<<<'SQL'
            ALTER TABLE dream_tags_before_event DROP FOREIGN KEY FK_46028FEFE65343C2
        SQL);
        $this->addSql(<<<'SQL'
            ALTER TABLE dream_tags_before_event DROP FOREIGN KEY FK_46028FEFBAD26311
        SQL);
        $this->addSql(<<<'SQL'
            ALTER TABLE dream_tags_before_feeling DROP FOREIGN KEY FK_C7CD05BDE65343C2
        SQL);
        $this->addSql(<<<'SQL'
            ALTER TABLE dream_tags_before_feeling DROP FOREIGN KEY FK_C7CD05BDBAD26311
        SQL);
        $this->addSql(<<<'SQL'
            ALTER TABLE dream_tags_dream_feeling DROP FOREIGN KEY FK_DBCC071EE65343C2
        SQL);
        $this->addSql(<<<'SQL'
            ALTER TABLE dream_tags_dream_feeling DROP FOREIGN KEY FK_DBCC071EBAD26311
        SQL);
        $this->addSql(<<<'SQL'
            DROP TABLE dream_tags_before_event
        SQL);
        $this->addSql(<<<'SQL'
            DROP TABLE dream_tags_before_feeling
        SQL);
        $this->addSql(<<<'SQL'
            DROP TABLE dream_tags_dream_feeling
        SQL);
        $this->addSql(<<<'SQL'
            DROP TABLE tag
        SQL);
        $this->addSql(<<<'SQL'
            ALTER TABLE dream ADD tags_before_event JSON DEFAULT NULL COMMENT '(DC2Type:json)', ADD tags_before_feeling JSON DEFAULT NULL COMMENT '(DC2Type:json)', ADD tags_dream_feeling JSON DEFAULT NULL COMMENT '(DC2Type:json)'
        SQL);
    }
}
