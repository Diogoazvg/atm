class OperationMachine
  include DepositError
  include WithdrawError

  def deposit_operation(request)
    data_parsed = parse_deposit(request)
    error = status_machine_error(data_parsed)
    if error
      @deposit.last_balance[:error] << 'caixa-em-uso'
      return @deposit.banknotes
    end

    @deposit = CashMachine.new(data_parsed)
    @deposit.banknotes
  end

  def withdraw_operation(request)
    data_parsed = parse_withdraw(request)
    return available_error unless cash_machine_available?
    return error_balance if unavailable_balance?(data_parsed)
    return duplicated_error if duplicated_withdraw?(data_parsed)

    Withdraw.new.execute(data_parsed, @deposit)
  end

  private

  def parse_deposit(data)
    {
      "machine": { "status_machine": data[:caixa][:caixaDisponivel],
                   "notes": {
                     "ten_notes": data[:caixa][:notas][:notasDez],
                     "twenty_notes": data[:caixa][:notas][:notasVinte],
                     "fifty_notes": data[:caixa][:notas][:notasCinquenta],
                     "hundred_notes": data[:caixa][:notas][:notasCem]
                   } }
    }
  end

  def parse_withdraw(data)
    {
      "withdraw": {
        "amount": data[:saque][:valor],
        "time": data[:saque][:horario]
      }
    }
  end
end
