
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

ALTER PROCEDURE p_lj_PR_PO
--@Org BIGINT,--��֯����
--@Code varchar(50),--�Ϻű���
--@StartDate datetime,--��ʼʱ��
--@EndDate datetime--����ʱ��

as
BEGIN

if OBJECT_ID('tempdb..#temp') is not null
drop table #temp
-- �� �ҳ� ���� 300 ��֯�� �ɹ�������Դ��������Ϊ �빺�� �ļ���
---- ��.a �ҳ����вɹ������µ� ***��Դ�������͵�ID*** ��ͳ�� ��Ŀ     SrcDocInfo_SrcDocTransType_EntityID(��Դ����ID)
		SELECT SrcDocInfo_SrcDocTransType_EntityID as ��Դ��������ID, COUNT(*) as ���� into #temp 
			from PM_PurchaseOrder A LEFT JOIN PM_POLine B ON A.ID = B.PurchaseOrder 
			where A.org = '1001708020135665' AND B.CurrentOrg = '1001708020135665' 
			GROUP BY SrcDocInfo_SrcDocTransType_EntityID 
			ORDER BY '����' --DESC 
		SELECT * FROM #temp 
		-- �õ�300��֯�²ɹ���������Ŀ
		SELECT SUM(#temp.����) as �ɹ������� from #temp 

---- ��.b  �ҳ�����***��Դ���***Ϊ"�빺��" ��			SrcDocType (��Դ��� 1 �빺��  0 �ֹ�)
		select SrcDocInfo_SrcDocTransType_EntityID,count(*) as ����  from PM_POLine where SrcDocType = '1' and CurrentOrg = '1001708020135665'  group by SrcDocInfo_SrcDocTransType_EntityID
---- ��.c  �������еĲɹ�����
		select A.org from PM_PurchaseOrder A LEFT JOIN PM_POLine B ON A.ID = B.PurchaseOrder where A.org = '1001708020135665'
---- ��.d  �ó� ���еĲɹ����� ���� �� �ֹ��� �� �빺�� ���  ��28936��

-- �ڴ��빺�������ҳ����е��빺����
---- ��.a �ҳ�����300��֯�µ��빺������
		Select b.PR from PR_PR A left join PR_PRLine B ON A.ID = B.PR where CurrentOrg = '1001708020135665'
---- ��.b 




select org from PM_PurchaseOrder 

-- �ҳ�������Դ��� Ϊ �빺����			SrcDocType (��Դ��� 1 �빺��  2 �ֹ�)




if OBJECT_ID('tempdb..#temp1') is not null
drop table #temp1
select PRNO,SrcDocInfo_SrcDocTransType_EntityID  into #temp1 from PM_POLine where   CurrentOrg = '1001708020135665'

SELECT * FROM #temp 
select SrcDocInfo_SrcDocTransType_EntityID ,Count(*) as ���� from #temp1 group by SrcDocInfo_SrcDocTransType_EntityID order by '����'


END
GO

exec p_lj_PR_PO