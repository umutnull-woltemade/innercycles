import { NextResponse } from "next/server";
import { zodiacSigns } from "@/content/zodiac/signs";

export async function GET(request: Request) {
  const { searchParams } = new URL(request.url);
  const element = searchParams.get("element");
  const modality = searchParams.get("modality");

  let filtered = zodiacSigns;

  if (element) {
    filtered = filtered.filter(
      (s) => s.element.toLowerCase() === element.toLowerCase()
    );
  }
  if (modality) {
    filtered = filtered.filter(
      (s) => s.modality.toLowerCase() === modality.toLowerCase()
    );
  }

  return NextResponse.json({
    count: filtered.length,
    signs: filtered.map((s) => ({
      slug: s.slug,
      name: s.name,
      symbol: s.symbol,
      element: s.element,
      modality: s.modality,
      dateRange: s.dateRange,
      rulingPlanet: s.rulingPlanet,
      keywords: s.keywords,
    })),
  });
}
