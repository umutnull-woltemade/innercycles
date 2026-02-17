import React from 'react';

interface InnerCyclesLogoProps {
  size?: number;
  className?: string;
  inline?: boolean;
}

const InnerCyclesLogoSVG = ({ size = 48 }: { size: number }) => (
  <svg
    xmlns="http://www.w3.org/2000/svg"
    viewBox="0 0 512 512"
    width={size}
    height={size}
    role="img"
    aria-label="InnerCycles"
  >
    <defs>
      <radialGradient id="icCore" cx="35%" cy="30%" r="65%" fx="30%" fy="25%">
        <stop offset="0%" stopColor="#FFF5F0"/>
        <stop offset="12%" stopColor="#FFEFEA"/>
        <stop offset="28%" stopColor="#FFE4DD"/>
        <stop offset="45%" stopColor="#FFD9D1"/>
        <stop offset="62%" stopColor="#F5C4BC"/>
        <stop offset="78%" stopColor="#E8ADA4"/>
        <stop offset="92%" stopColor="#DFA099"/>
        <stop offset="100%" stopColor="#D8968E"/>
      </radialGradient>
      <radialGradient id="icGlow" cx="38%" cy="32%" r="45%" fx="35%" fy="28%">
        <stop offset="0%" stopColor="#FFFFFF" stopOpacity="0.35"/>
        <stop offset="40%" stopColor="#FFF8F5" stopOpacity="0.15"/>
        <stop offset="100%" stopColor="#FFE8E2" stopOpacity="0"/>
      </radialGradient>
      <radialGradient id="icEdge" cx="50%" cy="50%" r="50%">
        <stop offset="85%" stopColor="#D8968E" stopOpacity="0"/>
        <stop offset="95%" stopColor="#C88A82" stopOpacity="0.08"/>
        <stop offset="100%" stopColor="#B87D75" stopOpacity="0.15"/>
      </radialGradient>
      <linearGradient id="icPearlSheen" x1="20%" y1="15%" x2="75%" y2="80%">
        <stop offset="0%" stopColor="#FFFFFF" stopOpacity="0.22"/>
        <stop offset="35%" stopColor="#FFF8F5" stopOpacity="0.08"/>
        <stop offset="100%" stopColor="#FFE4DD" stopOpacity="0"/>
      </linearGradient>
    </defs>
    <circle cx="256" cy="256" r="240" fill="url(#icCore)"/>
    <circle cx="256" cy="256" r="240" fill="url(#icGlow)"/>
    <circle cx="256" cy="256" r="240" fill="url(#icPearlSheen)"/>
    <circle cx="256" cy="256" r="240" fill="url(#icEdge)"/>
  </svg>
);

export function InnerCyclesLogo({
  size = 48,
  className = '',
  inline = false
}: InnerCyclesLogoProps) {
  if (inline) {
    return (
      <span className={className} style={{ display: 'inline-flex', alignItems: 'center' }}>
        <InnerCyclesLogoSVG size={size} />
      </span>
    );
  }

  return (
    <img
      src="/brand/app-logo.svg"
      alt="InnerCycles"
      width={size}
      height={size}
      className={className}
      style={{
        width: size,
        height: size,
        objectFit: 'contain'
      }}
    />
  );
}

export { InnerCyclesLogoSVG };
export default InnerCyclesLogo;
