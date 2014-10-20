module Account::EventsHelper

  def express_date
    ["tonight", "tomorrow", "Friday", "Saturday"]
  end

  def express_time
    [["8pm", "20"], ["9pm", "21"], ["10pm", "22"]]
  end

  def express_genre
    [
      ["Jazz musician #{black_price}", "Jazz musician", { data: { price: black_price, text: "Jazz musician"  } }],
      ["Classical musician #{black_price}", "Classical musician", { data: { price: black_price, text: "Classical musician"  } }],
      ["Indie singer/songwriter #{black_price}", "Indie singer/songwriter", { data: { price: black_price, text: "Indie singer/songwriter"  } }],
    ]
  end
  
  def black_price(price=Event::BLACK_PRICE)
    number_to_currency(price, unit: Event.black_currency.symbol, precision: 0)
  end
  
end