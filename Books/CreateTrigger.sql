SET @authors_count = 0;

DELIMITER //

CREATE TRIGGER i_Authors
AFTER INSERT ON Authors
FOR EACH ROW
BEGIN
    SET @authors_count = @authors_count + 1;
END //

DELIMITER ;
