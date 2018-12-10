SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		lj
-- Create date: 2018/12/10
-- Description:	PR转PO及时率报表
-- =============================================
CREATE PROCEDURE P_PR_PO_TimelinessRate 
(
	@Org BIGINT = '1001708020135665',		--组织
	--@Code varchar(50),						--料号
	@StartDT datetime = '2017-09-04',						--起始时间
	@EndDT datetime	 = '2018-07-31'					--结束时间
)
AS
BEGIN

	SET @EndDT  = DATEADD(day,1,@EndDT)	--结束日期 加一天
	IF object_id(N'tempdb.dbo.#temp_Result',N'U') is null
		BEGIN
		CREATE TABLE #temp_Result(			--创建存放结果的表
			
			PO_DocNo  nvarchar(50),				--采购单号
			POLine_SrcDocInfo_SrcDocNo nvarchar(50), --采购订单行的来源单行（即对应的请购单行）
			POLine_SrcDocInfo_SrcDocLineNo INT, --来源单据行号
			POLine_ID BIGINT,				--采购单行ID
			PO_Createdon datetime,			--PO 制单时间
			POLine_PurQtyTU Decimal,		--采购单行的采购数量
				
			
			PR_DocNo  NVARCHAR(50),			--请购单号
			PRLine_ID BIGINT,				--请购单行ID
			PRLine_DocLineNo INT,			--请购单行号
			PR_Approvedon datetime,			--PR 审核时间
			PRLine_ApprovedQtyPU Decimal,	--请购单行的核准数量（即采购单的 需求数量）

			--TimelinessRate	NVARCHAR(4)	default ''			--是否及时	
		)
		END
	ELSE
		BEGIN
		TRUNCATE TABLE #temp_Result			--删除所有行， 速度快些
		END
	

	if OBJECT_ID('tempdb..#temp') is not null
		drop table #temp
	BEGIN
			CREATE TABLE #temp(
			ID BIGINT,
			CREATEON DATETIME
		)
	END;

	WITH TEST AS -- 找出时间范围内的所有请购单行
	(
		select A.DocNo 采购单号,B.SrcDocInfo_SrcDocNo 来源单号,B.SrcDocInfo_SrcDocLineNo 来源行号, B.PurchaseOrder 采购单行ID, A.CreatedOn 采购制单时间, B.PurQtyTU 采购数量 from PM_PurchaseOrder A LEFT JOIN PM_POLine B ON A.ID = B.PurchaseOrder WHERE  A.Org = @Org AND B.SrcDocInfo_SrcDocNo <> '' AND B.CreatedOn BETWEEN @StartDT AND @EndDT 

	),
	TSET_T AS	--找出时间范围内的所有请购单转过来的采购单行
	(
		select A.DocNo 请购单号, B.PR 请购单行ID, B.DocLineNo 请购单行行号, A.Approvedon 请购审核时间 , B.ApprovedQtyPU 请购数量 from PR_PR A LEFT JOIN PR_PRLine B ON A.ID = B.PR WHERE  A.Org = '1001708020135665' AND B.CreatedOn BETWEEN @StartDT AND @EndDT 
	)
	INSERT INTO #temp_Result SELECT a.*,b.* FROM TEST A LEFT JOIN TSET_T B ON B.请购单号 = A.来源单号 WHERE B.请购单行行号 = A.来源行号 AND B.请购数量 <= A.采购数量
	alter table #temp_Result add TimelinessRate nvarchar(4) default ''
	-- 判断及时不及时 并且修改表中字段
	update #temp_Result  set TimelinessRate='及时' where Datediff(hh,#temp_Result.PR_Approvedon,#temp_Result.PO_Createdon ) < 24 
	update #temp_Result  set TimelinessRate='不及时' where Datediff(hh,#temp_Result.PR_Approvedon,#temp_Result.PO_Createdon ) >= 24 

	--SELECT A.PO_DocNo 采购单号,COUNT (*) 采购单行计数  FROM #temp_Result A group by A.PO_DocNo order by A.PO_DocNo
	SELECT  A.PO_DocNo,A.PR_DocNo,A.TimelinessRate FROM #temp_Result A order by A.TimelinessRate,A.PO_DocNo 
	
	Select TimelinessRate, COUNT(*) 计数 from #temp_Result group by TimelinessRate
	
END
GO

EXEC P_PR_PO_TimelinessRate '1001708020135665', '2017-11-21','2018-12-10'	

