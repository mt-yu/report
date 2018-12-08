查询语句 如下
-- 找出所有的PR  表一
    -- 统计 以PR 分组的 PR行 计数
    select A.DocNo,count(*) 计数 INTO #TEMP1 from PR_PR A left join PR_PRLine B ON A.ID = B.PR WHERE A.ORG = '1001708020135665'  group by A.DocNo order by '计数'
    -- 所有PR 行
    select A.DocNo from PR_PR A left join PR_PRLine B ON A.ID = B.PR WHERE A.ORG = '1001708020135665'

-- 找出PO - POLINE 下 所有有来源单号 不为空的 数据集 （即PR - PO 的 数据集）
    -- 找出所有的 PR 转 PO 的 PO 行
    select b.SrcDocInfo_SrcDocNo from PM_PurchaseOrder A left join PM_POLine B on A.ID = B.PurchaseOrder WHERE A.ORG = '1001708020135665'  AND B.SrcDocInfo_SrcDocNo <> '' 
    -- 统计 以 PR DOCNO 分组 的 POLINE 计数
    select b.SrcDocInfo_SrcDocNo, count(*) 计数  INTO #TEMP2 from PM_PurchaseOrder A left join PM_POLine B on A.ID = B.PurchaseOrder WHERE A.ORG = '1001708020135665'  AND B.SrcDocInfo_SrcDocNo <> '' group by b.SrcDocInfo_SrcDocNo order by '计数'

-- 找出 PR 中 没有 转 PO 的 PR 单号  （注意： 这里只找出了采购单号 而非 采购单行， 所以还需要进行具体的分析。）
    select A.DocNo, A.计数 from #TEMP1 A left join #TEMP2 B on A.DocNo = B.SrcDocInfo_SrcDocNo WHERE B.SrcDocInfo_SrcDocNo IS NULL
