//*****************************************************************************
//  Techniques for rendering the stage geometry.
//*****************************************************************************
float4x4 WorldMatrix;
float4x4 ViewMatrix;
float4x4 ProjectionMatrix;

//*****************************************************************************
struct VSInput
{
    float3 position	: POSITION;
	float4 color	: COLOR;
};

struct VSOutput
{
    float4 position : POSITION;
	float4 color	: COLOR;
};

//*****************************************************************************
VSOutput StageWorldSpaceVS( VSInput vsIn )
{
    VSOutput vsOut = ( VSOutput )0;

	//Transform the position into world coordinates.
    float4 worldPosition = mul( float4( vsIn.position.x, vsIn.position.y, vsIn.position.z, 1 ), WorldMatrix );
    float4 viewPosition = mul( worldPosition, ViewMatrix );
    vsOut.position = mul( viewPosition, ProjectionMatrix );

	vsOut.color = vsIn.color;

    return vsOut;
}

float4 StageWorldSpacePS( VSOutput input ) : COLOR0
{
    return input.color;
}

//*****************************************************************************
technique StageWorldSpace
{
    pass P0
    {
        VertexShader = compile vs_1_1 StageWorldSpaceVS( );
        PixelShader = compile ps_1_1 StageWorldSpacePS( );
    }
}