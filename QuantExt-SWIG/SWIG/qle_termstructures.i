/*
 Copyright (C) 2018 Quaternion Risk Management Ltd
 All rights reserved.
*/

#ifndef qle_termstructures_i
#define qle_termstructures_i

%include termstructures.i
%include volatilities.i
%include indexes.i

%{
using QuantExt::PriceTermStructure;
using QuantExt::InterpolatedPriceCurve;
using QuantExt::FxBlackVannaVolgaVolatilitySurface;
using QuantExt::BlackVarianceSurfaceMoneynessSpot;
using QuantExt::BlackVarianceSurfaceMoneynessForward;
//using QuantExt::SwaptionVolCube2;
using QuantExt::SwaptionVolCubeWithATM;
using QuantLib::SwaptionVolatilityCube;
using QuantExt::SwaptionVolatilityConstantSpread;
using QuantExt::SwapConventions;
using QuantExt::SwaptionVolatilityConverter;
using QuantExt::BlackVolatilityWithATM;

typedef boost::shared_ptr<BlackVolTermStructure> FxBlackVannaVolgaVolatilitySurfacePtr;
typedef boost::shared_ptr<BlackVolTermStructure> BlackVarianceSurfaceMoneynessSpotPtr;
typedef boost::shared_ptr<BlackVolTermStructure> BlackVarianceSurfaceMoneynessForwardPtr;
typedef boost::shared_ptr<SwaptionVolatilityStructure> QLESwaptionVolCube2Ptr;
typedef boost::shared_ptr<SwaptionVolatilityStructure> SwaptionVolCubeWithATMPtr;
typedef boost::shared_ptr<SwaptionVolatilityStructure> SwaptionVolatilityConstantSpreadPtr;
typedef boost::shared_ptr<BlackVolTermStructure> BlackVolatilityWithATMPtr;
typedef boost::shared_ptr<SwapConventions> SwapConventionsPtr;
typedef boost::shared_ptr<SwaptionVolatilityConverter> SwaptionVolatilityConverterPtr;
%}

%ignore PriceTermStructure;
class PriceTermStructure : public Extrapolator {
    public:
        QuantLib::Real price(QuantLib::Time t, bool extrapolate = false) const;
        QuantLib::Real price(const QuantLib::Date& d, bool extrapolate = false) const;
};

%template(PriceTermStructure) boost::shared_ptr<PriceTermStructure>;
IsObservable(boost::shared_ptr<PriceTermStructure>);

%template(PriceTermStructureHandle) Handle<PriceTermStructure>;
IsObservable(Handle<PriceTermStructure>);

%template(RelinkablePriceTermStructureHandle) RelinkableHandle<PriceTermStructure>;

%define export_Interpolated_Price_Curve(Name, Interpolator)

%{
typedef boost::shared_ptr<PriceTermStructure> Name##Ptr;
%}

%warnfilter(509) Name##Ptr;

%rename(Name) Name##Ptr;
class Name##Ptr : public boost::shared_ptr<PriceTermStructure> {
  public:
    %extend {
        Name##Ptr(const std::vector<QuantLib::Time>& times,
                  const std::vector<QuantLib::Real>& prices, 
                  const QuantLib::DayCounter& dc) {
            return new Name##Ptr(
                new InterpolatedPriceCurve<Interpolator>(times, 
                                                         prices, 
                                                         dc));
        }
        Name##Ptr(const std::vector<QuantLib::Time>& times,
                  const std::vector<QuantLib::Handle<QuantLib::Quote>>& quotes,
                  const QuantLib::DayCounter& dc) {
            return new Name##Ptr(
                new InterpolatedPriceCurve<Interpolator>(times, 
                                                         quotes, 
                                                         dc));
        }
        Name##Ptr(const std::vector<QuantLib::Date>& dates,
                  const std::vector<QuantLib::Real>& prices,
                  const QuantLib::DayCounter& dc) {
            return new Name##Ptr(
                new InterpolatedPriceCurve<Interpolator>(dates, 
                                                         prices, 
                                                         dc));
        }
        Name##Ptr(const std::vector<QuantLib::Date>& dates,
                  const std::vector<QuantLib::Handle<QuantLib::Quote>>& quotes,
                  const QuantLib::DayCounter& dc) {
            return new Name##Ptr(
                new InterpolatedPriceCurve<Interpolator>(dates, 
                                                         quotes, 
                                                         dc));
        }
        const std::vector<QuantLib::Time>& times() const {
            return boost::dynamic_pointer_cast<InterpolatedPriceCurve<Interpolator>>(*self)->times();
        }
        const std::vector<QuantLib::Real>& prices() const {
            return  boost::dynamic_pointer_cast<InterpolatedPriceCurve<Interpolator>>(*self)->prices();
        }
    }
};

%enddef

export_Interpolated_Price_Curve(LinearInterpolatedPriceCurve, Linear);
export_Interpolated_Price_Curve(BackwardFlatInterpolatedPriceCurve, BackwardFlat);
export_Interpolated_Price_Curve(LogLinearInterpolatedPriceCurve, LogLinear);
export_Interpolated_Price_Curve(CubicInterpolatedPriceCurve, Cubic);
export_Interpolated_Price_Curve(SplineCubicInterpolatedPriceCurve, SplineCubic);
export_Interpolated_Price_Curve(MonotonicCubicInterpolatedPriceCurve, MonotonicCubic);

%rename(QLESwaptionVolCube2) QLESwaptionVolCube2Ptr;
class QLESwaptionVolCube2Ptr : public boost::shared_ptr<SwaptionVolatilityStructure> {
  public:
    %extend {
        QLESwaptionVolCube2Ptr(const QuantLib::Handle<QuantLib::SwaptionVolatilityStructure>& atmVolStructure,
                               const std::vector<QuantLib::Period>& optionTenors, 
                               const std::vector<QuantLib::Period>& swapTenors,
                               const std::vector<QuantLib::Spread>& strikeSpreads,
                               const std::vector<std::vector<QuantLib::Handle<QuantLib::Quote>>>& volSpreads,
                               const SwapIndexPtr& swapIndexBase,
                               const SwapIndexPtr& shortSwapIndexBase, 
                               bool vegaWeightedSmileFit,
                               bool flatExtrapolation, 
                               bool volsAreSpreads = true) {
            const boost::shared_ptr<SwapIndex> swi = boost::dynamic_pointer_cast<SwapIndex>(swapIndexBase);
            const boost::shared_ptr<SwapIndex> shortSwi = boost::dynamic_pointer_cast<SwapIndex>(shortSwapIndexBase);
            return new QLESwaptionVolCube2Ptr(
                new QuantExt::SwaptionVolCube2(atmVolStructure,
                                               optionTenors,
                                               swapTenors,
                                               strikeSpreads,
                                               volSpreads,
                                               swi,
                                               shortSwi,
                                               vegaWeightedSmileFit,
                                               flatExtrapolation,
                                               volsAreSpreads));
        }
    }
};


%rename(FxBlackVannaVolgaVolatilitySurface) FxBlackVannaVolgaVolatilitySurfacePtr;
class FxBlackVannaVolgaVolatilitySurfacePtr : public boost::shared_ptr<BlackVolTermStructure> {
  public:
    %extend {
        FxBlackVannaVolgaVolatilitySurfacePtr(const QuantLib::Date& refDate, 
                                              const std::vector<QuantLib::Date>& dates,
                                              const std::vector<QuantLib::Volatility>& atmVols, 
                                              const std::vector<QuantLib::Volatility>& rr25d,
                                              const std::vector<QuantLib::Volatility>& bf25d, 
                                              const QuantLib::DayCounter& dc, 
                                              const QuantLib::Calendar& cal,
                                              const QuantLib::Handle<QuantLib::Quote>& fx, 
                                              const QuantLib::Handle<QuantLib::YieldTermStructure>& dom,
                                              const QuantLib::Handle<QuantLib::YieldTermStructure>& fore) {
            return new FxBlackVannaVolgaVolatilitySurfacePtr(
                new FxBlackVannaVolgaVolatilitySurface(refDate,
                                                       dates,
                                                       atmVols,
                                                       rr25d,
                                                       bf25d,
                                                       dc,
                                                       cal,
                                                       fx,
                                                       dom,
                                                       fore));
        }
    }
};


%rename(BlackVarianceSurfaceMoneynessSpot) BlackVarianceSurfaceMoneynessSpotPtr;
class BlackVarianceSurfaceMoneynessSpotPtr : public boost::shared_ptr<BlackVolTermStructure> {
  public:
    %extend {
        BlackVarianceSurfaceMoneynessSpotPtr(const QuantLib::Calendar& cal, 
                                             const QuantLib::Handle<QuantLib::Quote>& spot, 
                                             const std::vector<QuantLib::Time>& times,
                                             const std::vector<QuantLib::Real>& moneyness,
                                             const std::vector<std::vector<QuantLib::Handle<QuantLib::Quote>>>& blackVolMatrix,
                                             const QuantLib::DayCounter& dayCounter, 
                                             bool stickyStrike) {
            return new BlackVarianceSurfaceMoneynessSpotPtr(
                new BlackVarianceSurfaceMoneynessSpot(cal,
                                                      spot,
                                                      times,
                                                      moneyness,
                                                      blackVolMatrix,
                                                      dayCounter,
                                                      stickyStrike));
        }
    }
};

%rename(BlackVarianceSurfaceMoneynessForward) BlackVarianceSurfaceMoneynessForwardPtr;
class BlackVarianceSurfaceMoneynessForwardPtr : public boost::shared_ptr<BlackVolTermStructure> {
  public:
    %extend {
        BlackVarianceSurfaceMoneynessForwardPtr(const QuantLib::Calendar& cal, 
                                                const QuantLib::Handle<QuantLib::Quote>& spot, 
                                                const std::vector<QuantLib::Time>& times,
                                                const std::vector<QuantLib::Real>& moneyness,
                                                const std::vector<std::vector<QuantLib::Handle<QuantLib::Quote>>>& blackVolMatrix,
                                                const QuantLib::DayCounter& dayCounter, 
                                                const QuantLib::Handle<QuantLib::YieldTermStructure>& forTS,
                                                const QuantLib::Handle<QuantLib::YieldTermStructure>& domTS, 
                                                bool stickyStrike = false) {
            return new BlackVarianceSurfaceMoneynessForwardPtr(
                new BlackVarianceSurfaceMoneynessForward(cal,
                                                         spot,
                                                         times,
                                                         moneyness,
                                                         blackVolMatrix,
                                                         dayCounter,
                                                         forTS,
                                                         domTS,
                                                         stickyStrike));
        }
    }
};


%rename(SwaptionVolCubeWithATM) SwaptionVolCubeWithATMPtr;
class SwaptionVolCubeWithATMPtr : public boost::shared_ptr<SwaptionVolatilityStructure> {
  public:
    %extend {
        SwaptionVolCubeWithATMPtr(const boost::shared_ptr<SwaptionVolatilityStructure>& cube) {
            const boost::shared_ptr<QuantLib::SwaptionVolatilityCube> volCube
                = boost::dynamic_pointer_cast<QuantLib::SwaptionVolatilityCube>(cube);
            return new SwaptionVolCubeWithATMPtr(
                new SwaptionVolCubeWithATM(volCube));
        }
    }
};

%rename(SwaptionVolatilityConstantSpread) SwaptionVolatilityConstantSpreadPtr;
class SwaptionVolatilityConstantSpreadPtr : public boost::shared_ptr<SwaptionVolatilityStructure> {
  public:
    %extend {
        SwaptionVolatilityConstantSpreadPtr(const QuantLib::Handle<QuantLib::SwaptionVolatilityStructure>& atm,
                                            const QuantLib::Handle<QuantLib::SwaptionVolatilityStructure>& cube) {
            return new SwaptionVolatilityConstantSpreadPtr(
                new SwaptionVolatilityConstantSpread(atm, cube));
        }
        const QuantLib::Handle<QuantLib::SwaptionVolatilityStructure>& atmVol() {
            return  boost::dynamic_pointer_cast<SwaptionVolatilityConstantSpread>(*self)->atmVol();
        }
        const QuantLib::Handle<QuantLib::SwaptionVolatilityStructure>& cube() {
            return  boost::dynamic_pointer_cast<SwaptionVolatilityConstantSpread>(*self)->cube();
        }
    }
};

%rename(SwapConventions) SwapConventionsPtr;
class SwapConventionsPtr {
public:
  %extend {
    SwapConventionsPtr(QuantLib::Natural settlementDays, const QuantLib::Period& fixedTenor, 
        const QuantLib::Calendar& fixedCalendar, QuantLib::BusinessDayConvention fixedConvention, 
        const QuantLib::DayCounter& fixedDayCounter,
        const IborIndexPtr floatIndex) {
        
        boost::shared_ptr<IborIndex> iborIdx = boost::dynamic_pointer_cast<QuantLib::IborIndex>(floatIndex);
        return new SwapConventionsPtr(new SwapConventions(
            settlementDays, fixedTenor, fixedCalendar, fixedConvention, fixedDayCounter, iborIdx));
    }
    QuantLib::Natural settlementDays() const {
        return boost::dynamic_pointer_cast<SwapConventions>(*self)->settlementDays();
    }
    const QuantLib::Period& fixedTenor() const {
        return boost::dynamic_pointer_cast<SwapConventions>(*self)->fixedTenor();
    }
    const QuantLib::Calendar& fixedCalendar() const {
        return boost::dynamic_pointer_cast<SwapConventions>(*self)->fixedCalendar();
    }
    QuantLib::BusinessDayConvention fixedConvention() const {
        return boost::dynamic_pointer_cast<SwapConventions>(*self)->fixedConvention();
    }
    const QuantLib::DayCounter& fixedDayCounter() const {
        return boost::dynamic_pointer_cast<SwapConventions>(*self)->fixedDayCounter();
    }
    const IborIndexPtr floatIndex() const {
        return boost::dynamic_pointer_cast<SwapConventions>(*self)->floatIndex();
    }
  }
};

%rename(SwaptionVolatilityConverter) SwaptionVolatilityConverterPtr;
class SwaptionVolatilityConverterPtr {
public:
  %extend {
    SwaptionVolatilityConverterPtr(const QuantLib::Date& asof,
        const boost::shared_ptr<QuantLib::SwaptionVolatilityStructure>& svsIn,
        const QuantLib::Handle<QuantLib::YieldTermStructure>& discount,
        const QuantLib::Handle<QuantLib::YieldTermStructure>& shortDiscount,
        const SwapConventionsPtr& conventions,
        const SwapConventionsPtr& shortConventions,
        const QuantLib::Period& conventionsTenor, 
        const QuantLib::Period& shortConventionsTenor,
        const QuantLib::VolatilityType targetType, 
        const QuantLib::Matrix& targetShifts = QuantLib::Matrix()) {
        
        return new SwaptionVolatilityConverterPtr(
            new SwaptionVolatilityConverter(asof, svsIn, discount, shortDiscount, 
                conventions, shortConventions, conventionsTenor, shortConventionsTenor, 
                targetType, targetShifts));
    }
    SwaptionVolatilityConverterPtr(const QuantLib::Date& asof, 
        const boost::shared_ptr<QuantLib::SwaptionVolatilityStructure>& svsIn,
        const SwapIndexPtr& swapIndex,
        const SwapIndexPtr& shortSwapIndex, 
        const QuantLib::VolatilityType targetType,
        const QuantLib::Matrix& targetShifts = QuantLib::Matrix()) {
            
        boost::shared_ptr<QuantLib::SwapIndex> swpIdx = boost::dynamic_pointer_cast<QuantLib::SwapIndex>(swapIndex);
        boost::shared_ptr<QuantLib::SwapIndex> shtSwpIdx = boost::dynamic_pointer_cast<QuantLib::SwapIndex>(shortSwapIndex);
            
        return new SwaptionVolatilityConverterPtr(
            new SwaptionVolatilityConverter(asof, svsIn, swpIdx, shtSwpIdx, targetType, targetShifts));
    }
        
    boost::shared_ptr<QuantLib::SwaptionVolatilityStructure> convert() const {
        return boost::dynamic_pointer_cast<SwaptionVolatilityConverter>(*self)->convert();
    }
    QuantLib::Real& accuracy() {
        return boost::dynamic_pointer_cast<SwaptionVolatilityConverter>(*self)->accuracy();
    }
    QuantLib::Natural& maxEvaluations() {
        return boost::dynamic_pointer_cast<SwaptionVolatilityConverter>(*self)->maxEvaluations();
    }
  }
}; 




%rename(BlackVolatilityWithATM) BlackVolatilityWithATMPtr;
class BlackVolatilityWithATMPtr : public boost::shared_ptr<BlackVolTermStructure> {
public:
    %extend{
        BlackVolatilityWithATMPtr(const boost::shared_ptr<QuantLib::BlackVolTermStructure>& surface, 
                                  const QuantLib::Handle<QuantLib::Quote>& spot,
                                  const QuantLib::Handle<QuantLib::YieldTermStructure>& yield1, 
                                  const QuantLib::Handle<QuantLib::YieldTermStructure>& yield2) {
            return new BlackVolatilityWithATMPtr(
                new BlackVolatilityWithATM(surface,spot,yield1,yield2));
        }
        
        QuantLib::DayCounter dayCounter() const { return boost::dynamic_pointer_cast<BlackVolatilityWithATM>(*self)->dayCounter(); }
        
        QuantLib::Date maxDate() const { return boost::dynamic_pointer_cast<BlackVolatilityWithATM>(*self)->maxDate(); }
        
        QuantLib::Time maxTime() const { return boost::dynamic_pointer_cast<BlackVolatilityWithATM>(*self)->maxTime(); }
        
        const QuantLib::Date& referenceDate() const { return boost::dynamic_pointer_cast<BlackVolatilityWithATM>(*self)->referenceDate(); }
        
        QuantLib::Calendar calendar() const { return boost::dynamic_pointer_cast<BlackVolatilityWithATM>(*self)->calendar(); }
        
        QuantLib::Natural settlementDays() const { return boost::dynamic_pointer_cast<BlackVolatilityWithATM>(*self)->settlementDays(); }
        
        QuantLib::Rate minStrike() const { return boost::dynamic_pointer_cast<BlackVolatilityWithATM>(*self)->minStrike(); }
        
        QuantLib::Rate maxStrike() const { return boost::dynamic_pointer_cast<BlackVolatilityWithATM>(*self)->maxStrike(); }
        
    }
};

#endif
