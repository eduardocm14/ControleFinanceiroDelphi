unit Uprincipal;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.ExtCtrls, Vcl.ComCtrls, Data.DB,
  Vcl.Grids, Vcl.DBGrids, Vcl.StdCtrls, Vcl.Menus, FireDAC.Stan.Intf,
  FireDAC.Stan.Option, FireDAC.Stan.Param, FireDAC.Stan.Error, FireDAC.DatS,
  FireDAC.Phys.Intf, FireDAC.DApt.Intf, FireDAC.Stan.Async, FireDAC.DApt,
  FireDAC.Comp.DataSet, FireDAC.Comp.Client, Vcl.Imaging.jpeg,
  VclTee.TeeGDIPlus, VCLTee.TeEngine, VCLTee.Series, VCLTee.TeeProcs,
  VCLTee.Chart, Vcl.WinXPickers, Vcl.Mask, Vcl.DBCtrls;

type
  TFrmPrincipal = class(TForm)
    pnlPesquisar: TPanel;
    StatusBar1: TStatusBar;
    rgPesquisar: TRadioGroup;
    pmContasLancadas: TPopupMenu;
    CadastrarConta1: TMenuItem;
    N1: TMenuItem;
    PagarConta1: TMenuItem;
    lbedtPesquisar: TLabeledEdit;
    N2: TMenuItem;
    LanarConta1: TMenuItem;
    pnlContasLancadas: TPanel;
    pnlTotais: TPanel;
    N3: TMenuItem;
    AtualizarListadeContas1: TMenuItem;
    Label1: TLabel;
    LanareEditarConta1: TMenuItem;
    LanaremLote1: TMenuItem;
    Label7: TLabel;
    Label8: TLabel;
    dtpDataInicio: TDateTimePicker;
    dtpDataFim: TDateTimePicker;
    dbgContasLancadas: TDBGrid;
    pnlContasPagas: TPanel;
    dbgContasPagas: TDBGrid;
    btnPesqDatas: TButton;
    pmContasPagas: TPopupMenu;
    odascontaspagas1: TMenuItem;
    pnlTotaisContasLancadas: TPanel;
    pnlTotaisContasPagas: TPanel;
    dbedtVlrTotalLancado: TDBEdit;
    Label2: TLabel;
    Label3: TLabel;
    dbedtVlrTotalPago: TDBEdit;
    procedure rgPesquisarClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure CadastrarConta1Click(Sender: TObject);
    procedure dbgContasPagasDblClick(Sender: TObject);
    procedure dbg(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure FormCreate(Sender: TObject);
    procedure PagarConta1Click(Sender: TObject);
    procedure AtualizarListadeContas1Click(Sender: TObject);
    procedure LanareEditarConta1Click(Sender: TObject);
    procedure LanaremLote1Click(Sender: TObject);
    procedure dbgContasLancadasDrawColumnCell(Sender: TObject;
      const Rect: TRect; DataCol: Integer; Column: TColumn;
      State: TGridDrawState);
    procedure lbedtPesquisarChange(Sender: TObject);
    procedure btnPesqDatasClick(Sender: TObject);
    procedure odascontaspagas1Click(Sender: TObject);
  private
    procedure PesquisarPorDescricao;
    procedure PesquisarPorData;
    procedure LancarContas;
    procedure CadastrarContas;
    procedure PagarContas;
    { Private declarations }
  public
    { Public declarations }
  end;

var
  FrmPrincipal: TFrmPrincipal;

implementation

{$R *.dfm}

uses Ucontas, UlancarContas, UdmPrincipal, UpagtoContas, UlancarContasLote,
  Umetodos;

procedure TFrmPrincipal.FormCreate(Sender: TObject);
begin
  dmPrincipal.FDConnection.Connected := True;
  dmPrincipal.fdqContasLancadas.Active := True;
  dmPrincipal.fdqContasPagas.Active := True;

  StatusBar1.Panels[0].Text := 'Versão(Build) ' + FormatDateTime('dd/mm/yyyy' + ' - ' + 'hh:mm', Now) + ' (Desenv. Eduardo Moraes)';
  StatusBar1.Panels[1].Text := dmPrincipal.FDConnection.Params.Values['Database'];
end;

procedure TFrmPrincipal.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  case Key of
    VK_RETURN : LancarContas;
    VK_F3 : CadastrarContas;
    VK_F4 : LancarContas;
    VK_F5 : PagarContas;
  end;
end;

procedure TFrmPrincipal.FormShow(Sender: TObject);
begin
  dtpDataInicio.Date := Now;
  dtpDataFim.Date    := Now;
  PesquisarPorDescricao;
end;

procedure TFrmPrincipal.LanareEditarConta1Click(Sender: TObject);
begin
  LancarContas;
end;

procedure TFrmPrincipal.LanaremLote1Click(Sender: TObject);
var
  lFrmLancamentosLote: TFrmLancamentosLote;
begin
  try
    Application.CreateForm(TFrmLancamentosLote, lFrmLancamentosLote);
    lFrmLancamentosLote.ShowModal;
  finally
    lFrmLancamentosLote.Free;
  end;
end;

procedure TFrmPrincipal.rgPesquisarClick(Sender: TObject);
begin
  lbedtPesquisar.Clear;
  lbedtPesquisar.EditLabel.Caption := 'Procurar por: ' + rgPesquisar.Items[rgPesquisar.ItemIndex];
  PesqLocate(dmPrincipal.fdqContasLancadas, lbedtPesquisar.Text, 'descricao');
end;

procedure TFrmPrincipal.AtualizarListadeContas1Click(Sender: TObject);
begin
  dmPrincipal.fdqContasLancadas.Refresh;
  Self.dbgContasLancadas.Refresh;
  dmPrincipal.fdqContasLancadas.First;
end;

procedure TFrmPrincipal.btnPesqDatasClick(Sender: TObject);
begin
  if rgPesquisar.ItemIndex = 1 then
  begin
    dmPrincipal.fdqContasLancadas.Filtered := False;
    dmPrincipal.fdqContasLancadas.Filter := ' vencimento BETWEEN ' + QuotedStr(DateToStr(dtpDataInicio.Date)) +
                                            '                AND ' +  QuotedStr(DateToStr(dtpDataFim.Date));
    dmPrincipal.fdqContasLancadas.Filtered := True;
  end
  else if rgPesquisar.ItemIndex = 2 then
  begin
    dmPrincipal.fdqContasPagas.Filtered := False;
    dmPrincipal.fdqContasPagas.Filter := ' pagamento BETWEEN ' + QuotedStr(DateToStr(dtpDataInicio.Date)) +
                                         '               AND ' + QuotedStr(DateToStr(dtpDataFim.Date));
    dmPrincipal.fdqContasPagas.Filtered := True;
  end

end;

procedure TFrmPrincipal.CadastrarConta1Click(Sender: TObject);
begin
  CadastrarContas;
end;

procedure TFrmPrincipal.dbgContasLancadasDrawColumnCell(Sender: TObject;
  const Rect: TRect; DataCol: Integer; Column: TColumn; State: TGridDrawState);
begin
  {Alterando a cor da linha atual selecionada}
  if (dmPrincipal.fdqContasLancadasPAGAMENTO.IsNull) and
          (dmPrincipal.fdqContasLancadasSTATUS.AsInteger = 0) then
    TDBGrid(Sender).Canvas.Brush.Color := clOlive
  else if (dmPrincipal.fdqContasLancadasPAGAMENTO.IsNull) and
          (dmPrincipal.fdqContasLancadasSTATUS.AsInteger < 0) then
    TDBGrid(Sender).Canvas.Brush.Color := clYellow
  else
    TDBGrid(Sender).Canvas.Brush.Color := clRed;

  {Atualizando a visualização do DBGrid}
  dbgContasLancadas.Canvas.FillRect(Rect);
  TDBGrid(Sender).DefaultDrawColumnCell(Rect,DataCol,Column,State);
end;

procedure TFrmPrincipal.dbgContasPagasDblClick(Sender: TObject);
begin
  LancarContas;
end;

procedure TFrmPrincipal.dbg(Sender: TObject);
begin
  LancarContas;
end;

procedure TFrmPrincipal.PesquisarPorData;
begin
  lbedtPesquisar.Enabled := False;
  dtpDataInicio.Enabled := True;
  dtpDataFim.Enabled := True;
  btnPesqDatas.Enabled := True;
end;

procedure TFrmPrincipal.PesquisarPorDescricao;
begin
  lbedtPesquisar.Enabled := True;
  dtpDataInicio.Enabled := False;
  dtpDataFim.Enabled := False;
  btnPesqDatas.Enabled := False;
end;

procedure TFrmPrincipal.LancarContas;
var
  lFrmLancarContas: TFrmLancarContas;
begin
  try
    Application.CreateForm(TFrmLancarContas, lFrmLancarContas);
    lFrmLancarContas.ShowModal;
  finally
    Self.dbgContasLancadas.DataSource.DataSet.Refresh;
    Self.dbgContasLancadas.Refresh;
    lFrmLancarContas.Free;
  end;
end;

procedure TFrmPrincipal.lbedtPesquisarChange(Sender: TObject);
begin
  if rgPesquisar.ItemIndex = 0 then
  begin
    PesquisarPorDescricao;
    PesqLocate(dmPrincipal.fdqContasLancadas, lbedtPesquisar.Text, 'descricao');
  end
  else
  begin
    PesquisarPorData;
  end;
end;

procedure TFrmPrincipal.odascontaspagas1Click(Sender: TObject);
begin
  dmPrincipal.fdqContasPagas.Filtered := False;
  dmPrincipal.fdqContasPagas.Refresh;
end;

procedure TFrmPrincipal.CadastrarContas;
var
  lFrmContas: TFrmContas;
begin
  try
    Application.CreateForm(TFrmContas, lFrmContas);
    lFrmContas.Tag := 'C';
    lFrmContas.ShowModal;
  finally
    lFrmContas.Free;
  end;
end;

procedure TFrmPrincipal.PagarContas;
var
  lFrmPagto: TFrmPagto;
begin
  try
    Application.CreateForm(TFrmPagto, lFrmPagto);
    dmPrincipal.fdqContasLancadas.Edit;
    lFrmPagto.ShowModal;
  finally
    if dmPrincipal.fdqContasLancadas.State in [dsEdit] then
    begin
      dmPrincipal.fdqContasLancadas.Cancel;
      dmPrincipal.fdqContasLancadas.Refresh;
    end;
    Self.dbgContasLancadas.DataSource.DataSet.Refresh;
    Self.dbgContasLancadas.Refresh;
    Self.dbgContasPagas.DataSource.DataSet.Refresh;
    Self.dbgContasPagas.Refresh;
    lFrmPagto.Free;
  end;
end;

procedure TFrmPrincipal.PagarConta1Click(Sender: TObject);
begin
  PagarContas;
end;

end.
