module DepositError
  def status_machine_error(request)
    return unless request[:machine][:status_machine] && @deposit&.backend_banknotes&.[](:status_machine)

    true
  end
end
