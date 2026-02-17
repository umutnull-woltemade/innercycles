import Image from 'next/image';

interface InnerCyclesLogoProps {
  size?: number;
  priority?: boolean;
  className?: string;
}

export function InnerCyclesLogo({
  size = 48,
  priority = false,
  className = ''
}: InnerCyclesLogoProps) {
  return (
    <Image
      src="/brand/app-logo.svg"
      alt="InnerCycles"
      width={size}
      height={size}
      priority={priority}
      className={className}
      style={{
        width: size,
        height: size,
        objectFit: 'contain'
      }}
    />
  );
}

export default InnerCyclesLogo;
