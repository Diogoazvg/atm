class Withdraw
  def execute(request, machine)
    save_last_withdraw(request, machine)
    minimun_notes_operation(amount(request), machine)
  end

  private

  def amount(request)
    request[:withdraw][:amount]
  end

  def time(request)
    request[:withdraw][:time]
  end

  def minimun_notes_operation(amount, machine)
    amount_loop = amount
    inverse_notes = except_data(machine)
    inverse_notes.each_key do |k|
      next if amount_loop.zero?

      inverse_notes[k] += -(amount_loop / k.to_s.to_i)
      amount_loop = (amount_loop % k.to_s.to_i)
    end
    machine.last_balance = inverse_notes.merge(status_machine: machine.last_balance[:status_machine], error: [])
    machine.banknotes
  end

  def except_data(machine)
    machine.last_balance.except(:status_machine, :error)
  end

  def save_last_withdraw(request, machine)
    machine.last_withdraw = request
  end
end
