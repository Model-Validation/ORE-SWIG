/*
 Copyright (C) 2018, 2020 Quaternion Risk Management Ltd
 All rights reserved.

 This file is part of ORE, a free-software/open-source library
 for transparent pricing and risk analysis - http://opensourcerisk.org

 ORE is free software: you can redistribute it and/or modify it
 under the terms of the Modified BSD License.  You should have received a
 copy of the license along with this program.
 The license is also available online at <http://opensourcerisk.org>

 This program is distributed on the basis that it will form a useful
 contribution to risk analytics and model standardisation, but WITHOUT
 ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
 FITNESS FOR A PARTICULAR PURPOSE. See the license for more details.
*/

#ifndef qle_ccyswap_i
#define qle_ccyswap_i

%include qle_currencies.i
%include instruments.i
%include termstructures.i
%include money.i
%include marketelements.i
%include exchangerates.i

%{
using QuantExt::CrossCcySwap;
using QuantExt::CurrencySwap;
%}

%shared_ptr(CrossCcySwap)
class CrossCcySwap : public Swap {
  public:
    CrossCcySwap(const QuantLib::Leg& firstLeg,
                 const QuantLib::Currency& firstLegCcy,
                 const QuantLib::Leg& secondLeg,
                 const QuantLib::Currency& secondLegCcy);
    CrossCcySwap(const std::vector<QuantLib::Leg>& legs,
                 const std::vector<bool>& payer,
                 const std::vector<QuantLib::Currency>& currencies);
};

// %inline %{
//     ext::shared_ptr<CrossCcySwap> as_cross_currency_swap(
//                                       const ext::shared_ptr<Instrument>& inst) {
//                                         std::cout << typeid(inst).name() << std::endl;
//         return ext::dynamic_pointer_cast<CrossCcySwap>(inst);
//     }
// %}

// %inline %{
//     ext::shared_ptr<CrossCcySwap> as_cross_currency_swap(
//       const ext::shared_ptr<Instrument>& inst) {
//         std::cout << typeid(*inst).name() << std::endl;
//         // std::cout << decltype(*inst) << std::endl;
//         auto xccys = ext::dynamic_pointer_cast<CrossCcySwap>(inst);
//         std::cout << typeid(*xccys).name() << std::endl;
//         // std::cout << decltype(*xccys) << std::endl;
 
//         // std::cout << inst.static_type << std::endl;
//         // std::cout << inst.dynamic_type << std::endl;
//         // std::cout << xccys.static_type << std::endl;
//         // std::cout << xccys.dynamic_type << std::endl;
//         return xccys;
//     }
// %}

%inline %{
    CrossCcySwap as_cross_ccy_swap(
      const ext::shared_ptr<Instrument>& inst) {
        auto xccys = ext::dynamic_pointer_cast<CurrencySwap>(inst);
        return CrossCcySwap(xccys->legs(), xccys->payers(), xccys->currencies());
    }
%}


%{
using QuantExt::CrossCcySwapEngine;
%}

%shared_ptr(CrossCcySwapEngine)
class CrossCcySwapEngine : public PricingEngine {
  public:
    CrossCcySwapEngine(const QuantLib::Currency& ccy1,
                       const QuantLib::Handle<QuantLib::YieldTermStructure>& currency1DiscountCurve,
                       const QuantLib::Currency& ccy2,
                       const QuantLib::Handle<QuantLib::YieldTermStructure>& currency2DiscountCurve,
                       const QuantLib::Handle<QuantLib::Quote>& spotFX,
                       boost::optional<bool> includeSettlementDateFlows = boost::none,
                       const QuantLib::Date& settlementDate = QuantLib::Date(),
                       const QuantLib::Date& npvDate = QuantLib::Date());
};

#endif
