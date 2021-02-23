object dmPrincipal: TdmPrincipal
  OldCreateOrder = False
  Height = 336
  Width = 528
  object FDConnection: TFDConnection
    Params.Strings = (
      
        'Database=D:\Projetos\Delphi\ControleFinanceiro\BancoDados\CONTRO' +
        'LEFINANCEIRO.FDB'
      'User_Name=SYSDBA'
      'Password=masterkey'
      'Port=3050'
      'Server=localhost'
      'DriverID=FB')
    Connected = True
    LoginPrompt = False
    Left = 224
    Top = 40
  end
  object FDGUIxWaitCursor1: TFDGUIxWaitCursor
    Provider = 'Forms'
    Left = 72
    Top = 40
  end
  object FDPhysFBDriverLink1: TFDPhysFBDriverLink
    Left = 352
    Top = 48
  end
  object fdqProcurar: TFDQuery
    Connection = FDConnection
    Left = 224
    Top = 256
  end
  object dsContasLancadas: TDataSource
    DataSet = fdqContasLancadas
    Left = 72
    Top = 99
  end
  object fdqContasLancadas: TFDQuery
    Connection = FDConnection
    SQL.Strings = (
      'select'
      '    l.*,'
      '    c.descricao,'
      
        '    iif(l.pagamento is null, current_date - l.vencimento, 0) as ' +
        'STATUS,'
      '     case'
      '      when l.pagamento is not null then '#39'Pagamento Realizado'#39
      
        '      when iif(l.pagamento is null, current_date - l.vencimento,' +
        ' 0) = 0 then '#39'Dia de Pagamento'#39
      
        '      when iif(l.pagamento is null, current_date - l.vencimento,' +
        ' 0) = -1 then '#39'Falta 1 dia para vencer'#39
      
        '      when iif(l.pagamento is null, current_date - l.vencimento,' +
        ' 0) > 0 then '#39'Conta Atrasada'#39
      
        '      else '#39'Faltam '#39' || (iif(l.pagamento is null, current_date -' +
        ' l.vencimento, 0)*-1) || '#39' dias para vencer'#39
      '    end as informacao'
      'from lancamentos l'
      '    inner join contas c on(c.id = l.idconta)'
      'where l.pago = '#39'N'#39
      '    order by l.Vencimento')
    Left = 224
    Top = 99
    object fdqContasLancadasID: TIntegerField
      AutoGenerateValue = arAutoInc
      FieldName = 'ID'
      Origin = 'ID'
      ProviderFlags = [pfInUpdate, pfInWhere, pfInKey]
      Required = True
    end
    object fdqContasLancadasIDCONTA: TIntegerField
      Alignment = taCenter
      FieldName = 'IDCONTA'
      Origin = 'IDCONTA'
      Required = True
    end
    object fdqContasLancadasVENCIMENTO: TDateField
      Alignment = taCenter
      FieldName = 'VENCIMENTO'
      Origin = 'VENCIMENTO'
    end
    object fdqContasLancadasPAGAMENTO: TDateField
      Alignment = taCenter
      FieldName = 'PAGAMENTO'
      Origin = 'PAGAMENTO'
    end
    object fdqContasLancadasDESCRICAO: TStringField
      FieldName = 'DESCRICAO'
      Origin = 'DESCRICAO'
      ProviderFlags = []
      Size = 250
    end
    object fdqContasLancadasPAGO: TStringField
      FieldName = 'PAGO'
      Origin = 'PAGO'
      FixedChar = True
      Size = 1
    end
    object fdqContasLancadasSTATUS: TIntegerField
      AutoGenerateValue = arDefault
      FieldName = 'STATUS'
      Origin = 'STATUS'
      ProviderFlags = []
      ReadOnly = True
    end
    object fdqContasLancadasINFORMACAO: TStringField
      AutoGenerateValue = arDefault
      FieldName = 'INFORMACAO'
      Origin = 'INFORMACAO'
      ProviderFlags = []
      ReadOnly = True
      Size = 44
    end
    object fdqContasLancadasVALORCONTA: TFMTBCDField
      FieldName = 'VALORCONTA'
      Origin = 'VALORCONTA'
      currency = True
      Precision = 18
      Size = 2
    end
    object fdqContasLancadasVALORPAGTO: TFMTBCDField
      FieldName = 'VALORPAGTO'
      Origin = 'VALORPAGTO'
      currency = True
      Precision = 18
      Size = 2
    end
  end
  object dsContasPagas: TDataSource
    DataSet = fdqContasPagas
    Left = 72
    Top = 171
  end
  object fdqContasPagas: TFDQuery
    Connection = FDConnection
    SQL.Strings = (
      'select'
      '    l.*,'
      '    c.descricao,'
      
        '    iif(l.pagamento is null, current_date - l.vencimento, 0) as ' +
        'STATUS,'
      '     case'
      '      when l.pagamento is not null then '#39'Pagamento Realizado'#39
      
        '      when iif(l.pagamento is null, current_date - l.vencimento,' +
        ' 0) = 0 then '#39'Dia de Pagamento'#39
      
        '      when iif(l.pagamento is null, current_date - l.vencimento,' +
        ' 0) = -1 then '#39'Falta 1 dia para vencer'#39
      
        '      when iif(l.pagamento is null, current_date - l.vencimento,' +
        ' 0) > 0 then '#39'Conta Atrasada'#39
      
        '      else '#39'Faltam '#39' || (iif(l.pagamento is null, current_date -' +
        ' l.vencimento, 0)*-1) || '#39' dias para vencer'#39
      '    end as informacao'
      'from lancamentos l'
      '    inner join contas c on(c.id = l.idconta)'
      'where l.pago = '#39'P'#39
      '    order by l.pagamento, l.vencimento')
    Left = 224
    Top = 171
    object IntegerField1: TIntegerField
      AutoGenerateValue = arAutoInc
      FieldName = 'ID'
      Origin = 'ID'
      ProviderFlags = [pfInUpdate, pfInWhere, pfInKey]
      Required = True
    end
    object IntegerField2: TIntegerField
      Alignment = taCenter
      FieldName = 'IDCONTA'
      Origin = 'IDCONTA'
      Required = True
    end
    object DateField1: TDateField
      Alignment = taCenter
      FieldName = 'VENCIMENTO'
      Origin = 'VENCIMENTO'
    end
    object DateField2: TDateField
      Alignment = taCenter
      FieldName = 'PAGAMENTO'
      Origin = 'PAGAMENTO'
    end
    object StringField1: TStringField
      FieldName = 'DESCRICAO'
      Origin = 'DESCRICAO'
      ProviderFlags = []
      Size = 250
    end
    object StringField2: TStringField
      FieldName = 'PAGO'
      Origin = 'PAGO'
      FixedChar = True
      Size = 1
    end
    object IntegerField3: TIntegerField
      AutoGenerateValue = arDefault
      FieldName = 'STATUS'
      Origin = 'STATUS'
      ProviderFlags = []
      ReadOnly = True
    end
    object StringField3: TStringField
      AutoGenerateValue = arDefault
      FieldName = 'INFORMACAO'
      Origin = 'INFORMACAO'
      ProviderFlags = []
      ReadOnly = True
      Size = 44
    end
    object FMTBCDField1: TFMTBCDField
      FieldName = 'VALORCONTA'
      Origin = 'VALORCONTA'
      currency = True
      Precision = 18
      Size = 2
    end
    object FMTBCDField2: TFMTBCDField
      FieldName = 'VALORPAGTO'
      Origin = 'VALORPAGTO'
      currency = True
      Precision = 18
      Size = 2
    end
  end
end
