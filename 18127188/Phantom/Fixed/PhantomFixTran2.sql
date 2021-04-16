

DECLARE @RETRY_COUNT_CURRENT INT
DECLARE @RETRY_COUNT_MAXIMUM INT
DECLARE @ERROR_NUM INT
DECLARE @ERROR_MSG NVARCHAR(MAX)
 
SET @ERROR_NUM = 0
SET @RETRY_COUNT_CURRENT = 0
SET @RETRY_COUNT_MAXIMUM = 3
 

WHILE @RETRY_COUNT_CURRENT <  @RETRY_COUNT_MAXIMUM
BEGIN
    BEGIN TRANSACTION
    BEGIN TRY
			exec  ttkh__insert 38,N'Nguyen Van D',N'HCM','0992024315','CN0002'
       COMMIT
                   
       BREAK
   END TRY
   BEGIN CATCH
     SELECT @ERROR_NUM = ERROR_NUMBER(), @ERROR_MSG = ERROR_MESSAGE()
     PRINT @ERROR_MSG
     PRINT @ERROR_NUM
     ROLLBACK
     SET @RETRY_COUNT_CURRENT = @RETRY_COUNT_CURRENT + 1
     WAITFOR DELAY '00:00:01'
     CONTINUE
   END CATCH;
END

