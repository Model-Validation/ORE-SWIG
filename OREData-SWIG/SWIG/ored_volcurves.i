/*
 Copyright (C) 2019, 2020 Quaternion Risk Management Ltd
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

#ifndef ored_volcurves_i
#define ored_volcurves_i

%{
using ore::data::GenerticYieldVolCurve
using ore::data::SwaptionVolCurve
using namespace std;
%}

%shared_ptr(GenericYieldVolCurve)
class GenericYieldVolCurve {
	public:
		GenericYieldVolCurve(const Date& asof, const Loader& loader,
                            const CurveConfigurations& curveConfigs,
                            const ext::shared_ptr<GenericYieldVolatilityCurveConfig>& config,
                            const map<string, ext::shared_ptr<SwapIndex>>& requiredSwapIndices,
                            const map<string, ext::shared_ptr<GenericYieldVolCurve>>& requiredVolCurves,
                            const std::function<bool(const ext::shared_ptr<MarketDatum>& md, Period& expiry, Period& term)>&
                                matchAtmQuote,
                            const std::function<bool(const ext::shared_ptr<MarketDatum>& md, Period& expiry, Period& term, Real& strike)>&
                                matchSmileQuote,
                            const std::function<bool(const ext::shared_ptr<MarketDatum>& md, Period& term)>& matchShiftQuote,
                            const bool buildCalibrationInfo);
        const ext::shared_ptr<SwaptionVolatilityStructure>& volTermStructure();
        ext::shared_ptr<IrVolCalibrationInfo> calibrationInfo() const;
};

%shared_ptr(SwaptionVolCurve)
class SwaptionVolCurve : public GenericYieldVolCurve {
    public:
        SwaptionVolCurve(Date asof, SwaptionVolatilitySpec spec, const Loader& loader,
        const SwaptionVolatilityCurveSpec& spec() const;  

};


