unit UlancarContas;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.ExtCtrls,
  Vcl.WinXCalendars, Vcl.Mask, Vcl.DBCtrls, FireDAC.Stan.Intf,
  FireDAC.Stan.Option, FireDAC.Stan.Param, FireDAC.Stan.Error, FireDAC.DatS,
  FireDAC.Phys.Intf, FireDAC.DApt.Intf, FireDAC.Stan.Async, FireDAC.DApt,
  Data.DB, FireDAC.Comp.DataSet, FireDAC.Comp.Client, Vcl.ComCtrls, Vcl.Menus,
  Vcl.WinXPickers;

type
  TFrmLancarContas = class(TForm)
    pnlButtons: TPanel;
    btnNovo: TButton;
    btnAlterar: TButton;
    btnCancelar: TButton;
    btnSalvar: TButton;
    btnExcluir: TButton;
    pnlLancamentos: TPanel;
    dbedtContaCodigo: TDBEdit;
    Label1: TLabel;
    Label2: TLabel;
    Label4: TLabel;
    dbedtValor: TDBEdit;
    Label5: TLabel;
    dbedtVencimento: TDBEdit;
    Label6: TLabel;
    dbedtContaDescricao: TDBEdit;
    calendarValor: TCalendarView;
    lbEmEdicao: TLabel;
    procedure calendarValorClick(Sender: TObject);
    procedure dbedtContaCodigoExit(Sender: TObject);
    procedure btnNovoClick(Sender: TObject);
    procedure btnAlterarClick(Sender: TObject);
    procedure btnCancelarClick(Sender: TObject);
    procedure btnSalvarClick(Sender: TObject);
    procedure btnExcluirClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
  private
    { Private declarations }
    procedure HabilitarCadastro;
    procedure DesabilitarCadastro;
  public
    { Public declarations }
  end;

var
  FrmLancarContas: TFrmLancarContas;

implementation

{$R *.dfm}

uses UdmPrincipal, Umetodos, Uprincipal, Ucontas;

procedure TFrmLancarContas.btnAlterarClick(Sender: TObject);
begin
  HabilitarCadastro;
  dmPrincipal.fdqContasLancadas.Edit;
end;

procedure TFrmLancarContas.btnCancelarClick(Sender: TObject);
begin
  DesabilitarCadastro;
  dmPrincipal.fdqContasLancadas.Cancel;
end;

procedure TFrmLancarContas.btnExcluirClick(Sender: TObject);
begin
  if Application.MessageBox(PChar ('Deseja excluir o registro[' + dmPrincipal.fdqContasLancadasDESCRICAO.AsString + ']'), 'Confirma��o', MB_YESNO) = mrYes then
  begin
    dmPrincipal.fdqContasLancadas.Delete;
    dmPrincipal.fdqContasLancadas.Refresh;
  end;
end;

procedure TFrmLancarContas.btnNovoClick(Sender: TObject);
begin
  HabilitarCadastro;
  dmPrincipal.fdqContasLancadas.Append;
end;

procedure TFrmLancarContas.btnSalvarClick(Sender: TObject);
begin
  DesabilitarCadastro;
  dmPrincipal.fdqContasLancadas.Post;
end;

procedure TFrmLancarContas.calendarValorClick(Sender: TObject);
begin
  dbedtVencimento.Text := DateToStr(calendarValor.Date);
end;

procedure TFrmLancarContas.dbedtContaCodigoExit(Sender: TObject);
begin
  dbedtContaDescricao.Clear;
  if Trim(dbedtContaCodigo.Text) <> '' then
  begin
    dbedtContaDescricao.Text := Selecionar('Contas', 'Id', dbedtContaCodigo.Text);
    if Trim(dbedtContaDescricao.Text) = '' then
      dbedtContaCodigo.SetFocus;
  end;
end;

procedure TFrmLancarContas.DesabilitarCadastro;
begin
  btnNovo.Enabled := True;
  btnAlterar.Enabled := True;
  btnCancelar.Enabled := False;
  btnSalvar.Enabled := False;
  btnExcluir.Enabled := True;
  pnlLancamentos.Enabled := False;
  lbEmEdicao.Visible := False;
  btnNovo.SetFocus;
end;

procedure TFrmLancarContas.FormCloseQuery(Sender: TObject;
  var CanClose: Boolean);
begin
  dmPrincipal.fdqContasLancadas.Close;
end;

procedure TFrmLancarContas.FormCreate(Sender: TObject);
begin
  dmPrincipal.fdqContasLancadas.Open;
end;

procedure TFrmLancarContas.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if pnlLancamentos.Enabled then
  begin
    if Key = VK_F2 then
    begin
      try
        Application.CreateForm(TFrmContas, FrmContas);
        FrmContas.pnlButtons.Visible := False;
        FrmContas.pnlCadastro.Visible := False;
        FrmContas.Tag := 'P';
        FrmContas.ShowModal;
      finally
        Self.dbedtContaCodigo.Text    := FrmContas.ContaCod.ToString;
        Self.dbedtContaDescricao.Text := FrmContas.ContaDescricao;
        FrmContas.Free;
      end;
    end;
  end;
end;

procedure TFrmLancarContas.HabilitarCadastro;
begin
  btnNovo.Enabled := False;
  btnAlterar.Enabled := False;
  btnCancelar.Enabled := True;
  btnSalvar.Enabled := True;
  btnExcluir.Enabled := False;
  pnlLancamentos.Enabled := True;
  lbEmEdicao.Visible := True;
  dbedtContaCodigo.SetFocus;
end;

end.
