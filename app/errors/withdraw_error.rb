module WithdrawError
  def unavailable_balance?(request)
    sum_deposit < request[:withdraw][:amount]
  end

  def cash_machine_available?
    @deposit.last_balance[:status_machine] == true
  end

  def duplicated_withdraw?(request)
    return if last_withdraw.empty?

    deadline? && duplicated_value?(request)
  end

  def error_balance
    message_errors('valor-indisponivel')
  end

  def available_error
    message_errors('caixa-indisponivel')
  end

  def duplicated_error
    message_errors('saque-duplicado')
  end

  private

  def last_withdraw
    @deposit.last_withdraw
  end

  def duplicated_value?(request)
    last_withdraw[:withdraw][:amount] == request[:withdraw][:amount]
  end

  def deadline?
    (Time.current - last_withdraw[:withdraw][:time].to_time) < 10.minutes
  end

  def message_errors(error_message)
    @deposit.last_balance[:error] << error_message
    @deposit.banknotes
  end

  def sum_deposit
    notes_values = @deposit.last_balance.except(:status_machine, :error)
    notes_values.map { |k, v| [k.to_s, v].map(&:to_i) }.map { |v| v.inject(:*) }.sum
  end
end
