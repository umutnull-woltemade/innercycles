import Image from 'next/image';

interface VenusLogoProps {
  size?: number;
  priority?: boolean;
  className?: string;
}

export function VenusLogo({
  size = 48,
  priority = false,
  className = ''
}: VenusLogoProps) {
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

export default VenusLogo;