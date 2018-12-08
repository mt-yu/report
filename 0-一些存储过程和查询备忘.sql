--�йصı���

select * from CBO_PurchaseInfo	--��Ʒ�ɹ������Ϣ 
select * from PM_PMMatchedDetail --�ɹ�ƥ����Ϣ��ϸ
select *  from Base_Organization   --��֯����
select * from PM_PurchaseContract	--�ɹ���ͬ

select *  from PM_PurchaseOrder where DocNo = 'PO30181121023'   --�ɹ�����
select PRID,PRLINEID,PRNO  from PM_POLine where ID = '1001811210338995'  --�ɹ�������  --SrcDocInfo��SrcDocNo ��Դ���ݺ�  SrcDocLineNo  Դ�����кţ���Դ����

-- �ҵ� ��Ӧ���빺 ���� �� �빺������
select * from PR_PR	where DocNo = 'PR30181121005'	--�빺����
select * from PR_PRLine where PR = '1001811210317676'   --�빺����

select * from PR_PRDocType --�빺����������
select * from PM_PODocType --�ɹ�������������
-----------------------------------------------------------------------
--���������빺�Ͳɹ�����Ӧ��
select a.id a,b.id b,b.PurchaseOrder from 
PM_PurchaseOrder a left join PM_POLine b on a.id =b.PurchaseOrder 
where ISNULL(SrcDocInfo_SrcDocNo, '')!='' and a.Org=(select id from Base_Organization where code = '300')



-----------------------------------------------------------------------
--�ο� BOM ����ɱ� ��ʱ������
exec sp_helptext SP_AuctusGetBomSoftAmount

exec sp_databases; --�鿴���ݿ�
exec sp_tables;        --�鿴��
exec sp_columns 'PM_PurchaseOrder';--�鿴��

exec sp_helpIndex PM_PurchaseOrder;--�鿴����
exec sp_helpConstraint PM_PurchaseOrder;--Լ��
exec sp_stored_procedures;	--�鿴���д洢����
exec sp_helptext 'P_PM_FIClose' --�鿴�洢���̴������������
exec sp_helpdb;--���ݿ��������ѯ���ݿ���Ϣ
exec sp_helpdb master;
exec SP_DEPENDS 'PM_PurchaseOrder' --��ʾ�й����ݿ����������ϵ����Ϣ (������Щ������洢���̣���ͼ�����������)

-----------------------------------------------------------------------
--����洢���� ���ҵ��Ľ��������ʱ��

--��ȡĳһ����������ֶ�
if OBJECT_ID(N'tempdb..#p_columns',N'U') is not null
drop table #p_columns
create table #p_columns	--����һ������sp_columns ���ҵ��Ľ����
(
            TABLE_QUALIFIER		nvarchar(50),     
            TABLE_OWNER			nvarchar(50),
            TABLE_NAME			nvarchar(50),		   
            COLUMN_NAME			nvarchar(50),     --�ֶ���  
            DATA_TYPE			int,               
            TYPE_NAME			nvarchar(50),     --������   
            "PRECISION"			int,     
            "LENGTH"			int,			  --����
            SCALE				int,
            RADIX				int,  
            NULLABLE			bit,			  --�Ƿ����Ϊ��
            REMARKS				bit,         
            COLUMN_DEF			nvarchar(50),   
            SQL_DATA_TYPE		int,       
            SQL_DATETIME_SUB	int,          
            CHAR_OCTET_LENGTH   int,       
            ORDINAL_POSITION    int,				--���
            IS_NULLABLE         nvarchar(4),        --�Ƿ����Ϊ��
            SS_DATA_TYPE		int,
)
insert into #p_columns exec sp_columns 'PR_PR'	--����洢���̲��ҵ��Ľ��������ʱ��
select COLUMN_NAME,TYPE_NAME,"LENGTH",NULLABLE from #p_columns --������ʱ���е�Ҫ֪������
go


------------------------------------------------------------------------------------------

if OBJECT_ID('tempdb..#temp') is not null
drop table #temp;

with 
t1 as
(
	select  b.PR,
			a.DocNo,
			a.PRDocType,
			b.ID,
			b.ItemInfo_ItemID,
			b.DocLineNo,
			b.ItemInfo_ItemCode,
			b.ItemInfo_ItemName,
			b.DeliveryDate
		from PR_PR a  left join PR_PRLine b
		on a.ID=b.PR 
		where Org=(select ID from Base_Organization where Code='300')  
),
t2 as
(
	select a.ID,
		    a.DocNo,
			a.CreatedOn,
			a.Status,
			b.DocLineNo,
			b.ItemInfo_ItemCode,
			b.ItemInfo_ItemName,
			b.ItemInfo_ItemID, 
			b.SrcDocInfo_SrcDocNo,
			b.PRID,	
			b.PRLineID,
			b.PRNO
		from PM_PurchaseOrder a left join PM_POLine b
		on a.ID=b.PurchaseOrder
		where Org=(select ID from Base_Organization where Code='300') 
)
select PR into #temp from t1 a left join t2 b on a.DocNo=b.PRNO
where ISNULL(PRNO,'')=''

select * from #temp


