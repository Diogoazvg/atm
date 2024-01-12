class CashMachine
  attr_accessor :last_withdraw, :last_balance

  def initialize(data_machine)
    @data_machine = data_machine
    @last_withdraw = {}
    @last_balance = backend_banknotes
  end

  def status_machine
    @data_machine[:machine][:status_machine]
  end

  def notes
    @data_machine[:machine][:notes]
  end

  def backend_banknotes
    { status_machine:,
      "10": notes[:ten_notes],
      "20": notes[:twenty_notes],
      "50": notes[:fifty_notes],
      "100": notes[:hundred_notes],
      error: [] }.to_a.reverse.to_h
  end

  def banknotes
    {
      caixa: {
        caixaDisponivel: @last_balance[:status_machine],
        notasDez: last_balance[:"10"],
        notasVinte: last_balance[:"20"],
        notasCinquenta: last_balance[:"50"],
        notasCem: last_balance[:"100"],
        erros: last_balance[:error]
      }
    }
  end
end
